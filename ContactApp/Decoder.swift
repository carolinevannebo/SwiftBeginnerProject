//
//  Decoder.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 12/09/2023.
//

import Foundation

class MyBundle { }

extension Bundle {
    func decoded<T: Decodable>(_ file: String) -> T {
            guard let url = self.url(forResource: file, withExtension: nil) else {
                fatalError("Failed to locate \(file) in bundle.")
            }

            guard let data = try? Data(contentsOf: url) else {
                fatalError("Failed to load \(file) from bundle.")
            }

            let decoder = JSONDecoder()

            guard let loaded = try? decoder.decode(T.self, from: data) else {
                fatalError("Failed to decode \(file) from bundle.")
            }

            return loaded
    }
    
    func decode<T: Decodable>(forName file: String) -> T {
        guard let filePath = Bundle(for: MyBundle.self).path(forResource: file, ofType: "json") else {
        //guard let filePath = Bundle.main.path(forAuxiliaryExecutable: file) else {
            fatalError("Failed to find path for \(file) from bundle.")
        }
        
        let fileUrl = URL(fileURLWithPath: filePath)
        
        let data = try? Data(contentsOf: fileUrl)
        
        guard let numbers = try? JSONDecoder().decode(T.self, from: data!) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
            
        return numbers
    }
}
