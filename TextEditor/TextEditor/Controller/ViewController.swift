import UIKit



class ViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    private var menuOut = false
    
    private let headerAttributes = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
    private let bodyAttributes = [NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
    
    public var textTitle: String?
    public var currentTXTDocument: TXTDocument?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textView.delegate = self


    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
        if (currentTXTDocument == nil) {
            
            saveAs()
        }
        else {
            
            save()
        }
    }
    
    
    @IBAction func openButtonTapped(_ sender: Any) {
        
        burgerMenuTapped(self)
        print(" open button tapped ")
        
    }
    
    @IBAction func newFileButtonTapped(_ sender: Any) {
        textView.text = " "
        currentTXTDocument = nil
        burgerMenuTapped(self)
        self.navigationItem.title = "Text Editor"
    }
    
    
    @IBAction func burgerMenuTapped(_ sender: Any) {
        
        if menuOut == false {
            leadingConstraint.constant = 150
            trailingConstraint.constant = -150
            menuOut = true
        } else {
            
            leadingConstraint.constant = 0
            trailingConstraint.constant = 0
            menuOut = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            print("animation complete")
        }
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier else { return }
        guard let vc = segue.destination as? ListFilesTableViewController else {return}
        if identifier == "displayFiles" {
            vc.delegate = self
            print("Transition to our files ")
        }
    }
    
    public func txtDocumentDidSet() {
        
        guard currentTXTDocument != nil else { return }
        
        do {
            textView.text.removeAll()
            
            
            let content     = try currentTXTDocument?.getContent()
            textView.text   = content
            self.navigationItem.title = try currentTXTDocument?.getTitle()
        }
        catch {
            
            print("Failed to load file!")
        }
    }
    
    
    private func save() {
        
        let textFile = textView.text
        
        guard (textFile != nil) else { return }
        
        currentTXTDocument?.setContent(content: textFile!)
        
        saveFile(txtDocument: currentTXTDocument!)
    }
    
    private func saveAs() {
        
        let alert = UIAlertController(title: "Enter the title", message: nil, preferredStyle: .alert)
        alert.addTextField()
        
        let submitAction = UIAlertAction(title: "Save", style: .default) { [unowned alert, weak self] _ in
            
            guard (self != nil) else { return }
            
            let fileName = alert.textFields?.first?.text
            let textFile = self?.textView.text
            
            guard (fileName != nil && textFile != nil) else { return }
            
            self?.currentTXTDocument = TXTDocument(title: fileName!, content: textFile!, relativePath: TXTDocument.titleWithExtension(fileName!))
            
            self?.txtDocumentDidSet()
            
            self?.saveFile(txtDocument: (self?.currentTXTDocument)!)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        burgerMenuTapped(alert)
    }
    
    
    ///Mark: TextViewStyle
    
    private func highlightFirstLineInTextView(textView: UITextView) {
        
        
        let textAsNSString = textView.text as NSString
        let lineBreakRange = textAsNSString.range(of: "\n")
        let newAttributedText = NSMutableAttributedString(attributedString: textView.attributedText)
        let boldRange: NSRange
        if lineBreakRange.location < textAsNSString.length {
            boldRange = NSRange(location: 0, length: lineBreakRange.location)
        } else {
            boldRange = NSRange(location: 0, length: textAsNSString.length)
            
        }
        
        newAttributedText.addAttribute(NSAttributedString.Key.font, value: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline), range: boldRange)
        textView.attributedText = newAttributedText
        textView.autocorrectionType = .no
        textView.backgroundColor = .secondarySystemBackground
        textView.textColor = .secondaryLabel
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.layer.cornerRadius = 20
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let textAsNSString = self.textView.text as NSString
        let replaced = textAsNSString.replacingCharacters(in: range, with: text) as NSString
        let boldRange = replaced.range(of: "\n")
        if boldRange.location <= range.location {
            self.textView.typingAttributes = self.headerAttributes
        } else {
            self.textView.typingAttributes = self.bodyAttributes
        }
        
        return true
    }
    //
}

