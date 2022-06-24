//
//  SFSymbolSerializerDocument.swift
//  SFSymbols Serializer
//
//  Created by Ashley Chapman on 22/06/2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct SFSymbolSerializerDocument: FileDocument {
    
    // Variables
    @ObservedObject var project: SFSymbolsObject = SFSymbolsObject()
    
    var name: String = "Untitled"
    var json: String = "{ 'items': [] }"

    init(name: String = "Untitled", json: String = "{ 'items': [] }") {
        self.name = name
        self.json = json
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        do {
            let decodedProject = try jsonDecoder.decode(SFSymbolsObject.self, from: self.json.data(using: .utf8)!)
            
            self.project = decodedProject
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }

    static var readableContentTypes: [UTType] { [.json] }

    init(configuration: ReadConfiguration) throws {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        do {
            let decodedProject = try jsonDecoder.decode(SFSymbolsObject.self, from: data)
            
            self.project = decodedProject
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        let data = try jsonEncoder.encode(self.project)
        let fileWrapper = FileWrapper(regularFileWithContents: data)
        
        if self.name != "" {
            fileWrapper.filename = self.name
        }
        
        return fileWrapper
    }
}
