//
//  InputFieldViewModifier.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 23/10/2023.
//

import SwiftUI
import Combine

enum InputType {
    case phoneNumber
    case email
    case normalText
}

struct InputFieldViewModifier: ViewModifier {
    @FocusState private var keyIsFocused: Bool
    @Environment(\.colorScheme) var colorScheme
    
    let countries: [CPData] = Bundle.main.decode(forName: "CountryNumbers")
    
    var input: Binding<String>
    let inputType: InputType
    
    var presentSheet: Binding<Bool>
    //var text: String = ""
    
    var countryCode: Binding<String>// = "+47"
    var countryFlag: Binding<String>// = "🇳🇴"
    var countryPattern: Binding<String>// = "### ## ###"
    
    var customPlaceholder: String?
    
    func body(content: Content) -> some View {
        content.overlay(
            Group {
                switch inputType {
                    case .phoneNumber: phoneInputView
                    case .email: emailInputView
                    case .normalText: normalTextInputView
                }
            }
        ).padding()
    }
    
    var phoneInputView: some View {
        HStack {
            Button(action: { presentSheet.wrappedValue = true }) {
                HStack {
                    Text(countryFlag.wrappedValue)
                    Text(countryCode.wrappedValue)
                }
                .padding(10)
                .frame(minWidth: 80, minHeight: 47)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
                .foregroundColor(foregroundColor)
            }
            .padding(.trailing, 4)
            
            TextField("", text: input).placeholder(when: input.wrappedValue.isEmpty) {
                Text("Phone number").foregroundColor(.secondary)
            }
            .keyboardType(.phonePad)
            .onReceive(Just(input)) { _ in
                applyPatternOnNumbers(&input.wrappedValue, pattern: countryPattern.wrappedValue, replacementCharacter: "#")
            }
            .padding(10)
            .frame(minWidth: 80, minHeight: 47)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
        }
    }
    
    var emailInputView: some View {
        TextField("", text: input).placeholder(when: input.wrappedValue.isEmpty) {
            Text("Email").foregroundColor(.secondary)
        }
        .keyboardType(.emailAddress)
        .padding(10)
        .frame(minWidth: 80, minHeight: 47)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
    }
    
    var normalTextInputView: some View {
        TextField("", text: input).placeholder(when: input.wrappedValue.isEmpty) {
            Text(customPlaceholder ?? "Text").foregroundColor(.secondary)
        }
        .keyboardType(.namePhonePad)
        .padding(10)
        .frame(minWidth: 80, minHeight: 47)
        .background(backgroundColor, in: RoundedRectangle(cornerRadius: 10, style: .continuous))
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
