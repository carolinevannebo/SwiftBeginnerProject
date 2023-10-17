//
//  CPData.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 12/09/2023.
//

import Foundation

struct CPData: Identifiable, Codable {
    let id: String
    let name: String
    let flag: String
    let code: String
    let dial_code: String
    let pattern: String
    let limit: Int
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.flag = try container.decode(String.self, forKey: .flag)
        self.code = try container.decode(String.self, forKey: .code)
        self.dial_code = try container.decode(String.self, forKey: .dial_code)
        self.pattern = try container.decode(String.self, forKey: .pattern)
        self.limit = try container.decode(Int.self, forKey: .limit)
    }
}
