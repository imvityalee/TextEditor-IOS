import Foundation

struct FileModel {
    
    private static let fileManager         = FileManager.default
    private static let appDirectory        = FileManager.default.urls(for: .documentDirectory,
                                                                      in: .userDomainMask).first
    
    /// Возвращает массив относительных ссылок на файлы (в виде строк), находящиеся в файловой системе.
    /// Эти значения хранить в массиве, а в ячейки передавать конвертированные значение (convertRelativePathToTitle())
    
    public static func getFileURLs(sorted: Bool) throws -> [String] {
        
        guard let appDirectory = appDirectory else { throw FileModelErrors.appDirectoryIsNil }
        
        var urlList = try fileManager.subpathsOfDirectory(atPath: appDirectory.path).filter { $0.contains(".txt") }
        
        urlList = try fileManager.subpathsOfDirectory(atPath: appDirectory.path).filter { !$0.contains(".Trash") }
        
        if sorted {
            
            urlList = urlList.sorted() { (currentElement, nextElement) -> Bool in
                
                return currentElement.localizedCaseInsensitiveCompare(nextElement) == .orderedAscending
            }
            
        }
        
        return urlList
    }
    
    public static func getAppDirectory() throws -> URL {
        
        guard let url = appDirectory else { throw FileModelErrors.appDirectoryIsNil }
        
        return url
    }
    
    /// Конвертирует относительную ссылку в title (например: преобразует "Test/Document.txt" в "Document")
    
    public static func convertRelativePathToTitle(relativePath: String) -> String {
        
        let title = URL(fileURLWithPath: relativePath).deletingPathExtension().lastPathComponent
        
        return title
    }
}

// MARK: - Read/Write txt-files

extension FileModel {
    
    /// Принимает относительную ссылку на файл (в виде строки) и возвращает объект txtDocument, который содержит
    /// в себе title, content и relativePath
    
    public static func readFile(fileRelativePath path: String) throws -> TXTDocument {
        
        guard let fullPath  = appDirectory?.appendingPathComponent(path) else {
            
            throw FileModelErrors.appDirectoryIsNil
        }
        
        let title                   = URL(fileURLWithPath: path).deletingPathExtension().lastPathComponent
        
        let content                 = try String(contentsOf: fullPath, encoding: .utf8)
        
        let txtDocument             = TXTDocument(title: title, content: content, relativePath: path)
        
        return txtDocument
    }
    
    public static func saveFile(txtDocument:TXTDocument) throws {
        
        var filePath: String!
        
        if let relativePath         = try txtDocument.getRelativePath() { filePath = relativePath }
        
        let filePathURL             = appDirectory?.appendingPathComponent(filePath)
        
        if let filePathURL          = filePathURL {
            
            let content             = try txtDocument.getContent()
            
            try content.write(to: filePathURL,
                              atomically: false,
                              encoding: .utf8)
        }
        
        else { throw FileModelErrors.errorWithSavingFile }
    }
    
    public static func deleteFile(fileRelativePath path: String) throws {
        
        guard appDirectory != nil else { throw FileModelErrors.appDirectoryIsNil }
        
        try fileManager.removeItem(at: appDirectory!.appendingPathComponent(path))
    }
}
