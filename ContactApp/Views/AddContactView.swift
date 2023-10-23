//
//  AddContactView.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 04/09/2023.
//

import SwiftUI
import PhotosUI
import Combine

struct AddContactView: View {
    var didAddContact: ((Contact) -> ())
    
    init(didAddContact: @escaping (Contact) -> Void) {
        self.didAddContact = didAddContact
    }
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var phoneNumber: String = ""
    @State var email: String = ""
    @State var address: String = ""
    @State var image: String = ""
    
    @State private var avatarItem: PhotosPickerItem?
    @State private var avatarImage: Image?
    
    @State var isShowingErrorAlert: Bool = false
    @State var errorMessage: String = ""
    
    @Environment(\.colorScheme) var colorScheme
    @FocusState private var keyIsFocused: Bool
    @State private var searchCountry: String = ""
    @State var presentSheet = false
    
    @State var countryCode: String = "+47"
    @State var countryFlag: String = "🇳🇴"
    @State var countryPattern: String = "### ## ###"
    @State var countryLimit: Int = 17
    
    func addContact() async {
        var base64Image = ""
        
        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
            base64Image = data.base64EncodedString()
        }
        
        if isEmptyInput(firstName, "Please enter firstname.") == true {
            return ()
        }
        
        if isEmptyInput(lastName, "Please enter lastname.") == true {
            return ()
        }
        
        //TODO: check phone number
        
        if isEmptyInput(email, "Please enter email.") == true {
            return ()
        }
            
        if isValidEmail(email) == false {
            errorMessage = "Please enter a valid email."
            isShowingErrorAlert = true
            return()
        }
        
        if isEmptyInput(address, "Please enter address.") == true {
            return()
        }
        
        if isEmptyInput(base64Image, "Please upload a photo.") == true {
            return ()
        }
            
        let newContact = Contact(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            address: address,
            email: email,
            image: base64Image
        )
        
        didAddContact(newContact)
        
        return()
    }
    
    func isEmptyInput(_ input: String, _ message: String) -> Bool {
        if input == nil ?? "" {
            errorMessage = message
            isShowingErrorAlert = true
            return true
        }
        return false
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .center) {
                Text("New contact").font(.title).padding()
                Form {
                    
                    TextField("", text: $firstName)
                        .modifier(
                            InputFieldViewModifier(input: $firstName, inputType: InputType.normalText, presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern, customPlaceholder: "First name")
                        )
                    
                    TextField("", text: $lastName)
                        .modifier(
                            InputFieldViewModifier(input: $lastName, inputType: InputType.normalText, presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern, customPlaceholder: "Last name")
                        )
                    
                    TextField("", text: $phoneNumber)
                        .modifier(
                            InputFieldViewModifier(input: $phoneNumber, inputType: InputType.phoneNumber, presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern)
                        )

                    TextField("", text: $email)
                        .modifier(
                            InputFieldViewModifier(input: $email, inputType: InputType.email, presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern)
                        )
                    
                    TextField("", text: $address)
                        .modifier(
                            InputFieldViewModifier(input: $address, inputType: InputType.normalText, presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern, customPlaceholder: "Address")
                        )

                    
//                    InputFieldView(input: $firstName, text: "First name", presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern)
//
//                    InputFieldView(input: $lastName, text: "Last name", presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern)
//
//                    InputFieldView(input: $phoneNumber, text: "Phone number", presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern)
//
//                    InputFieldView(input: $email, text: "Email", presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern)
//
//                    InputFieldView(input: $address, text: "Address", presentSheet: $presentSheet, countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern)
                    
                    if let avatarImage {
                        avatarImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                    }
                } // Form
                .onChange(of: avatarItem) { _ in
                    Task {
                        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
                            if let uiImage = UIImage(data: data) {
                                avatarImage = Image(uiImage: uiImage)
                                return
                            }
                        }
                        errorMessage = "Could not upload avatar."
                        isShowingErrorAlert = true
                    }
                } // PhotosPicker/ Form
                CountryCodesView(countryCode: $countryCode, countryFlag: $countryFlag, countryPattern: $countryPattern, countryLimit: $countryLimit, presentSheet: $presentSheet)
                
                HStack {
                    PhotosPicker("Select avatar", selection: $avatarItem, matching: .images).buttonStyle(OnboardingButtonStyle())
                    
                    Button("Add new contact") {
                        Task {
                            await addContact()
                        }
                    }.buttonStyle(OnboardingButtonStyle())
                }.padding(.horizontal) // HStack
            } // VStack
            .alert("Oops! An error occured", isPresented: $isShowingErrorAlert) {
                Text("Some actions")
            } message: {
                Text($errorMessage.wrappedValue)
            }
        } // NavigationStack
        .onTapGesture {
            hideKeyboard()
        }
    }
}


struct InputFieldView: View {
    @FocusState private var keyIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    let countries: [CPData] = Bundle.main.decode(forName: "CountryNumbers")
    
    var input: Binding<String>
    var presentSheet: Binding<Bool>
    var text: String = ""
    
    var countryCode: Binding<String>// = "+47"
    var countryFlag: Binding<String>// = "🇳🇴"
    var countryPattern: Binding<String>// = "### ## ###"
    
    init(input: Binding<String>, text: String, presentSheet: Binding<Bool>, countryCode: Binding<String>, countryFlag: Binding<String>, countryPattern: Binding<String>) {
        self.input = input
        self.text = text
        self.presentSheet = presentSheet
        self.countryCode = countryCode
        self.countryFlag = countryFlag
        self.countryPattern = countryPattern
    }
    
    var body: some View {
        if text == "Phone number" {
            HStack {
                Button {} label: {
                    Text("\(countryFlag.wrappedValue) \(countryCode.wrappedValue)")
                        .padding(10)
                        .frame(minWidth: 80, minHeight: 47)
                        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .foregroundColor(foregroundColor)
                }.onTapGesture {
                    print("Before button tapped")
                    print("presentSheet: \(presentSheet.wrappedValue)")
                    print("keyIsFocused: \(keyIsFocused)")
                    presentSheet.wrappedValue = true
                    print("After button tapped")
                    print("presentSheet: \(presentSheet.wrappedValue)")
                }
                
                TextField("", text: input)
                    .placeholder(when: input.wrappedValue.isEmpty) {
                        Text(text)
                            .foregroundColor(.secondary)
                    }
                    .focused($keyIsFocused)
                    .keyboardType(.phonePad)
                    .onReceive(Just(input)) { _ in
                        applyPatternOnNumbers(&input.wrappedValue, pattern: countryPattern.wrappedValue, replacementCharacter: "#")
                    }
                    .padding(10)
                    .frame(minWidth: 80, minHeight: 47)
                    .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
            } // HStack
        } else if text == "Email" {
            HStack {
                TextField("", text: input).placeholder(when: input.wrappedValue.isEmpty) {
                    Text(text).foregroundColor(.secondary)
                }
                .placeholder(when: input.wrappedValue.isEmpty) {
                    Text(text).foregroundColor(.secondary)
                }
                .keyboardType(.emailAddress)
                .padding(10)
                .frame(minWidth: 80, minHeight: 47)
                .background(backgroundColor, in:
                                RoundedRectangle(cornerRadius: 10, style: .continuous))
            } // HStack
        } else {
            HStack {
                TextField("", text: input).placeholder(when: input.wrappedValue.isEmpty) {
                    Text(text).foregroundColor(.secondary)
                }
                .keyboardType(.namePhonePad)
                .padding(10)
                .frame(minWidth: 80, minHeight: 47)
                .background(backgroundColor, in:
                                RoundedRectangle(cornerRadius: 10, style: .continuous))
            } // HStack
        }
    }
    
    func applyPatternOnNumbers(_ stringvar: inout String, pattern: String, replacementCharacter: Character) {
        var pureNumber = stringvar.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else {
                stringvar = pureNumber
                return
            }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacementCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        stringvar = pureNumber
    }
    
    var foregroundColor: Color {
        if colorScheme == .dark {
            return Color(.white)
        } else {
            return Color(.black)
        }
    }
    
    var backgroundColor: Color {
        if colorScheme == .dark {
            return Color(.systemGray5)
        } else {
            return Color(.systemGray6)
        }
    }
}

extension View {
    func hideKeyboard() {
        let resign = #selector(UIResponder.resignFirstResponder)
        UIApplication.shared.sendAction(resign, to: nil, from: nil, for: nil)
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
            
            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

struct AddContactView_Previews: PreviewProvider {
    static var previews: some View {
        return AddContactView() { product in
        }
    }
}

// -----------------IGNORE--------------------------

//struct AddContactView: View {
//    @Binding var contacts: [Contact]
//
//    @State var firstName: String = ""
//    @State var lastName: String = ""
//    @State var phoneNumber: String = ""
//    @State var email: String = ""
//    @State var address: String = ""
//    @State var image: String = ""
//
//    @State private var avatarItem: PhotosPickerItem?
//    @State private var avatarImage: Image?
//
//    @State var isShowingErrorAlert: Bool = false
//
//    func addContact() async {
//        if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
//            let base64Image = data.base64EncodedString()
//            let newContact = Contact(
//                firstName: firstName,
//                lastName: lastName,
//                phoneNumber: phoneNumber,
//                address: address,
//                email: email,
//                image: base64Image
//            )
//            contacts.append(newContact)
//        } else {
//            isShowingErrorAlert = true
//        }
//        return()
//    }
//
//    var body: some View {
//        VStack { // gjør denne til NavigationView
//            Form {
//                TextField("First name", text: $firstName)
//                TextField("Last name", text: $lastName)
//                TextField("Phone number", text: $phoneNumber)
//                TextField("Email", text: $email).textCase(.lowercase)
//                TextField("Address", text: $address)
//
//                PhotosPicker("Select avatar", selection: $avatarItem, matching: .images)
//                if let avatarImage {
//                    avatarImage
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 300, height: 300)
//                }
//            }.onChange(of: avatarItem) { _ in
//                Task {
//                    if let data = try? await avatarItem?.loadTransferable(type: Data.self) {
//                        if let uiImage = UIImage(data: data) {
//                            avatarImage = Image(uiImage: uiImage)
//                            return
//                        }
//                    }
//
//                    print("Failed")
//                }
//            }
//            HStack {
//                Button("Add") {
//                    Task {
//                        await addContact()
//                    }
//                }
//            }
//        }.alert("Oops! An error occured", isPresented: $isShowingErrorAlert) {
//            Text("Some actions")
//        } message: {
//            Text("Some message")
//        }
//    }
//}

// ---------------------------------------------
