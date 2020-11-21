//
//  ViewControllerExtensions.swift
//  TextEditor
//
//  Created by Victor Lee on 10/23/20.
//  Copyright © 2020 victorLee. All rights reserved.
//

import Foundation


// MARK: - Methods which work with FileModel

extension ViewController {
    
    public func saveFile(txtDocument: TXTDocument) {
        
        do {
            
            try FileModel.saveFile(txtDocument: txtDocument)
        }
        
        catch TXTDocumentsErrors.titleIsEmpty {
            
            print("Title is empty!")
        }
        
        catch {
            
            print("Something went wrong...")
        }
    }
}

extension ViewController: ListDelegate {
    func setTXTDocument(txtDocument: TXTDocument) {
        
        currentTXTDocument = txtDocument
        
        txtDocumentDidSet()
    }
}
