import Foundation

indirect enum TXTDocumentsErrors : Error {
    
    case titleIsNil
    case titleIsEmpty
    case contentIsNil
    case relativePathIsNil
    
    case errors([TXTDocumentsErrors])
}
