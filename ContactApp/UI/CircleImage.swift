//
//  CircleImage.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 23/10/2023.
//

import SwiftUI

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

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(contact: Contact.demoContacts[0], width: 50, height: 50, strokeColor: Color.white, lineWidth: 0)
    }
}
