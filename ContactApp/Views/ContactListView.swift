//
//  ContactListView.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 04/09/2023.

import SwiftUI

struct ContactListView: View {
    init(contacts: [Contact], isAdmin: Bool) {
        self.contacts = contacts
        self.isAdmin = isAdmin
    }
    
    @State var contacts: [Contact]
    @State var isPresentingAddContactView: Bool = false
    let isAdmin: Bool
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                ContactList(contacts: contacts)
            } // VStack
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if isAdmin {
                        Button {
                            isPresentingAddContactView = true
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.accentColor)
                                .padding(.trailing, 20)
                        }
                    }
                }
            }
            .sheet(isPresented: $isPresentingAddContactView) {
                AddContactView() { contact in
                    contacts.append(contact)
                    isPresentingAddContactView = false
                }
            }
        }
    }
}

struct ContactList: View {
    let contacts: [Contact]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts) { contact in
                    NavigationLink {
                        ContactDetailView(contact: contact)
                    } label: {
                        ListItemView(contact: contact)
                    }
                }
            }
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView(contacts: Contact.demoContacts, isAdmin: true)
    }
}

// -----------------IGNORE--------------------------
//struct HorizontalListItemView: View {
//    let contact: Contact
//
//    var body: some View {
//        VStack (alignment: .center) {
//            CircleImage(contact: contact, width: 250, height: 250, strokeColor: Color.white, lineWidth: 4)
//            Text("\(contact.firstName) \(contact.lastName)").foregroundColor(.accentColor).font(.headline).textCase(.uppercase)
//            Spacer()
//            VStack (alignment: .leading, spacing: 5) {
//                HStack {
//                    Image(systemName: "phone").foregroundColor(.accentColor).scaledToFit()
//                    Text("+47 \(contact.phoneNumber)").foregroundColor(.secondary)
//                }
//                HStack {
//                    Image(systemName: "mail").foregroundColor(.accentColor).scaledToFit()
//                    Text("\(contact.email)").foregroundColor(.secondary)
//                }
//                HStack {
//                    Image(systemName: "house").foregroundColor(.accentColor).scaledToFit()
//                    Text("\(contact.address)").foregroundColor(.secondary)
//                }
//            }
//        }.padding(EdgeInsets(top: 20, leading: 55, bottom: 20, trailing: 55))
//    }
//}

//struct Task5: View {
//    init(contacts: [Contact], isAdmin: Bool) {
//        self.contacts = contacts
//        self.isAdmin = isAdmin
//    }
//
//    @State var contacts: [Contact]
//    let isAdmin: Bool
//
//    var body: some View {
//        NavigationStack {
//            HStack (alignment: .center) {
//                Text("Contacts").font(.largeTitle).foregroundColor(.accentColor).padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0)).fontWeight(.bold)
//                Spacer()
//
//                if isAdmin {
//                    NavigationLink {
//                        AddContactView(contacts: $contacts)
//                    } label: {
//                        Image(systemName: "plus").resizable().frame(width: 20, height: 20).foregroundColor(.accentColor).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
//                    }.padding()
//                } else {
//                    Text("") // guest user
//                }
//            }
//            ContactList(contacts: contacts)
//        }
//    }
//}
//
//struct Task2: View {
//    let contacts: [Contact]
//
//    var body: some View {
//        NavigationStack {
//            ScrollView (.horizontal) {
//                HStack (alignment: .center, spacing: 0) {
//                    ForEach(contacts) { contact in
//                        NavigationLink {
//                            ContactDetailView(contact: contact)
//                        } label: {
//                            HorizontalListItemView(contact: contact)
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
// ---------------------------------------------
