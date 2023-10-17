//
//  Decoder.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 12/09/2023.
//

import Foundation

class MyBundle { }

extension Bundle {
    func decode<T: Decodable>(forName file: String) -> T {
        guard let filePath = Bundle(for: MyBundle.self).path(forResource: file, ofType: "json") else {
            fatalError("Failed to find path for \(file) from bundle.")
        }
        
        let fileUrl = URL(fileURLWithPath: filePath)
        
        let data = try? Data(contentsOf: fileUrl)
            
        guard let result = try? JSONDecoder().decode(T.self, from: data!) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
            
        return result
    }
}
