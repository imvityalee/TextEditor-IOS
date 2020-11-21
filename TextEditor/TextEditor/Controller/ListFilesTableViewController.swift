

import UIKit

class ListFilesTableViewController: UITableViewController {
    
    var directories = Array<String>()
    
    var delegate: ListDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directories = getFileURLs()

    }
    
    private func getFileURLs(sorted: Bool = true) -> [String] {
        
        do {
            
            return try FileModel.getFileURLs(sorted: sorted)
        }
        
        catch {
            
            print("Failed to load file list!")
        }
        
        return []
    }
    
    private func readFile(relativePath: String) -> TXTDocument {
        do {
            
            return try FileModel.readFile(fileRelativePath: relativePath)
        }
        
        catch {
            
            print("Failed to load file")
        }
        
        return TXTDocument()
    }
    
    private func deleteFileAtIndex(index: Int) {
        
        do {
            
            try FileModel.deleteFile(fileRelativePath: directories[index])
        }
        
        catch {
            
            print("Failed to delete file")
        }
    }
}

/// MARK: - TableViewDataSource + TableViewDelegate

extension ListFilesTableViewController {
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return directories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "listFilesTableViewCell", for: indexPath) as! ListFilesTableViewCell
        
        cell.cellTitleLabel.text = directories[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        let relativePath = directories[indexPath.row]
        let file         = readFile(relativePath: relativePath)
            
        delegate?.setTXTDocument(txtDocument: file)
        navigationController?.popViewController( animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            deleteFileAtIndex(index: indexPath.row)
            
            directories = getFileURLs()
            
            tableView.reloadData()
        }
    }
    
}

protocol ListDelegate {
    func setTXTDocument(txtDocument: TXTDocument)
}
