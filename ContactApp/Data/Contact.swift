//
//  Contact.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 04/09/2023.
//

import Foundation

struct Contact: Identifiable, Codable {
    var id: UUID? = UUID()
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let address: String
    let email: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case phoneNumber
        case address
        case email
        case image
    }
    
}

extension Contact {
    init(from decoder: Decoder) throws {
        let object = try decoder.container(keyedBy: CodingKeys.self)
        
        if let id = try? object.decode(UUID.self, forKey: .id) {
                self.id = id
            } else {
                self.id = UUID()
            }
        
        self.firstName = try object.decode(String.self, forKey: .firstName)
        self.lastName = try object.decode(String.self, forKey: .lastName)
        self.phoneNumber = try object.decode(String.self, forKey: .phoneNumber)
        self.address = try object.decode(String.self, forKey: .address)
        self.email = try object.decode(String.self, forKey: .email)
        self.image = try object.decode(String.self, forKey: .image)
    }
    
    static let demoContacts: [Contact] = Bundle.main.decode(forName: "DemoContacts")

}
