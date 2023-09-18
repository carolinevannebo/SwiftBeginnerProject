//
//  ContactDetailView.swift
//  Lecture3
//
//  Created by Caroline Vannebo on 04/09/2023.
//

import SwiftUI

struct ContactDetailView: View {
    let contact: Contact
    
    var body: some View {
        ZStack {
            if let data = Data(base64Encoded: contact.image),
                let uiImage = UIImage(data: data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
            } else {
                Image(contact.image).resizable().scaledToFill().ignoresSafeArea()
            }
            RoundedRectangle(cornerRadius: 40).foregroundColor(.white).opacity(0.7).frame(width: 350).padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
            VStack {
                Text("\(contact.firstName) \(contact.lastName)").font(.largeTitle).textCase(.uppercase).foregroundColor(.accentColor)
                Spacer()
                    VStack (alignment: .leading) {
                        Divider()
                        HStack {
                            Image(systemName: "phone").resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(.accentColor)
                            Text("+47 \(contact.phoneNumber)").font(.title2).foregroundColor(.black)
                        }
                        Divider()
                        HStack {
                            Image(systemName: "mail").resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(.accentColor)
                            Text("\(contact.email)").font(.title2).foregroundColor(.black)
                        }
                        Divider()
                        HStack {
                            Image(systemName: "house").resizable().scaledToFit().frame(width: 30, height: 30).foregroundColor(.accentColor)
                            Text("\(contact.address)").font(.title2).foregroundColor(.black)
                        }
                        Divider()
                }.padding()
            }.frame(width: 300).padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
        }
    }
}

struct ContactDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ContactDetailView(contact: .init(firstName: "Zacke", lastName: "Berglund", phoneNumber: "000 00 000", address: "Konows gate 63", email: "zacke@berglund.no", image: "dog5"))
    }
}
