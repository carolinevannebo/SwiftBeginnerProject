//
//  ContactListView.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 04/09/2023.

import SwiftUI

struct ContactListView: View {
    
    var body: some View {
        //Task1(contacts: Contact.demoContacts)
        //Task2(contacts: Contact.demoContacts)
        //Task5(contacts: Contact.demoContacts, isAdmin: true)
        TaskClosures(contacts: Contact.demoContacts, isAdmin: true)
    }
}

struct TaskClosures: View {
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
                Task1(contacts: contacts)
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
                AddContactViewClosure() { contact in
                    contacts.append(contact)
                    isPresentingAddContactView = false
                }
            }
        }
    }
}

struct Task5: View {
    init(contacts: [Contact], isAdmin: Bool) {
        self.contacts = contacts
        self.isAdmin = isAdmin
    }
    
    @State var contacts: [Contact]
    let isAdmin: Bool
    
    var body: some View {
        NavigationStack {
            HStack (alignment: .center) {
                Text("Contacts").font(.largeTitle).foregroundColor(.accentColor).padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0)).fontWeight(.bold)
                Spacer()
                
                if isAdmin {
                    NavigationLink {
                        AddContactView(contacts: $contacts)
                    } label: {
                        Image(systemName: "plus").resizable().frame(width: 20, height: 20).foregroundColor(.accentColor).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                    }.padding()
                } else {
                    Text("") // guest user
                }
            }
            Task1(contacts: contacts)
        }
    }
}

struct Task2: View {
    let contacts: [Contact]
    
    var body: some View {
        NavigationStack {
            ScrollView (.horizontal) {
                HStack (alignment: .center, spacing: 0) {
                    ForEach(contacts) { contact in
                        NavigationLink {
                            ContactDetailView(contact: contact)
                        } label: {
                            HorizontalListItemView(contact: contact)
                        }
                    }
                }
            }
        }
    }
}

struct Task1: View {
    let contacts: [Contact]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts) { contact in
                    NavigationLink {
                        ContactDetailView(contact: contact)
                    } label: {
                        VerticalListItemView(contact: contact)
                    }
                }
            }
        }
    }
}

struct CircleImage: View {
    let contact: Contact
    let width: CGFloat
    let height: CGFloat
    let strokeColor: Color
    let lineWidth: CGFloat
    
    var body: some View {
        if let data = Data(base64Encoded: contact.image),
           let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage).resizable().scaledToFill()
                .frame(width: width, height: height)
                .clipShape(Circle())
                .overlay(Circle().stroke(strokeColor, lineWidth: lineWidth))
                .shadow(radius: 5).padding()
        } else {
            Image(contact.image).resizable().scaledToFill()
                .frame(width: width, height: height)
                .clipShape(Circle())
                .overlay(Circle().stroke(strokeColor, lineWidth: lineWidth))
                .shadow(radius: 5).padding()
        }
    }
}

struct HorizontalListItemView: View {
    let contact: Contact
    
    var body: some View {
        VStack (alignment: .center) {
            CircleImage(contact: contact, width: 250, height: 250, strokeColor: Color.white, lineWidth: 4)
            Text("\(contact.firstName) \(contact.lastName)").foregroundColor(.accentColor).font(.headline).textCase(.uppercase)
            Spacer()
            VStack (alignment: .leading, spacing: 5) {
                HStack {
                    Image(systemName: "phone").foregroundColor(.accentColor).scaledToFit()
                    Text("+47 \(contact.phoneNumber)").foregroundColor(.secondary)
                }
                HStack {
                    Image(systemName: "mail").foregroundColor(.accentColor).scaledToFit()
                    Text("\(contact.email)").foregroundColor(.secondary)
                }
                HStack {
                    Image(systemName: "house").foregroundColor(.accentColor).scaledToFit()
                    Text("\(contact.address)").foregroundColor(.secondary)
                }
            }
        }.padding(EdgeInsets(top: 20, leading: 55, bottom: 20, trailing: 55))
    }
}

struct VerticalListItemView: View {
    let contact: Contact
    
    var body: some View {
        HStack (alignment: .center, spacing: 0) {
            CircleImage(contact: contact, width: 50, height: 50, strokeColor: Color.white, lineWidth: 2)
            Text("\(contact.firstName) \(contact.lastName)").foregroundColor(.primary)
        }
    }
}

struct ContactListView_Previews: PreviewProvider {
    static var previews: some View {
        ContactListView()
    }
}
