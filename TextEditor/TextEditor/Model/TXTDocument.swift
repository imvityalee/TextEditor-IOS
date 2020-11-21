import Foundation

struct TXTDocument {
    
    private var title       : String?
    private var content     : String?
    private var relativePath: String?
    private(set) var isEmpty: Bool
    
    init() {
        
        isEmpty = true
    }
    
    init(title: String, content: String, relativePath: String) {
        
        self.title          = title
        self.content        = content
        self.relativePath   = relativePath
        self.isEmpty        = false
    }
    
    // TODO filePath if needed
    
    public mutating func setTitle(title: String) {
        
        self.title = title
    }
    
    public func getTitle() throws -> String {
        
        guard let title = title else { throw TXTDocumentsErrors.titleIsNil }
        if title.isEmpty { throw TXTDocumentsErrors.titleIsEmpty }
        
        return title
    }
    
    public mutating func setContent(content: String) {
        
        self.content = content
    }
    
    public func getContent() throws -> String {
        
        guard let content = content else { throw TXTDocumentsErrors.contentIsNil }
        
        return content
    }
    
    public static func titleWithExtension(_ title: String) -> String {
        
        return title + ".txt"
    }
    
    public func getRelativePath() throws -> String? {
        
        guard let relativePath = relativePath else { throw TXTDocumentsErrors.relativePathIsNil }
        
        return relativePath
    }
    
    public mutating func setRelativePath(relativePath: String) {
        
        self.relativePath = relativePath
    }
}
