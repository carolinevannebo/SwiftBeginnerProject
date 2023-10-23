//
//  ListItemView.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 23/10/2023.
//

import SwiftUI

struct ListItemView: View {
    let contact: Contact
    
    var body: some View {
        HStack (alignment: .center, spacing: 0) {
            CircleImage(contact: contact, width: 65, height: 65, strokeColor: Color.white, lineWidth: 0)
            Text("\(contact.firstName) \(contact.lastName)").foregroundColor(.primary)
        }
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        ListItemView(contact: Contact.demoContacts[0])
    }
}
