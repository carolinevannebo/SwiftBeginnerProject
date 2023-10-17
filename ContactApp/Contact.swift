//
//  Contact.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 04/09/2023.
//

import Foundation
import SwiftUI

struct Contact: Identifiable {
    var id: UUID = UUID()
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let address: String
    let email: String
    let image: String
}
