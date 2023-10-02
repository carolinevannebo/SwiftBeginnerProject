//
//  ProfileView.swift
//  Lecture3
//
//  Created by Caroline Vannebo on 25/09/2023.
//

import SwiftUI
import KeychainSwift

enum AppStorageKeys: String {
    case username
    case password
}

struct ProfileView: View {
    @State var username: String?
    @State var password: String?
    @State var isLoggedIn: Bool = false
    @State var isSigningUp: Bool = false
    @State var isSigningIn: Bool = false
    
    func onAppear() {
        if let username = UserDefaults.standard.object(forKey: AppStorageKeys.username.rawValue) as? String {
            self.username = username
        }
        
        let keychain = KeychainSwift()
        if let password = keychain.get(AppStorageKeys.password.rawValue) {
            self.password = password
        }
        
        guard username != nil && username != "" else {
            isLoggedIn = false
            isSigningIn = true
            isSigningUp = true
            return
        }
        
        guard password != nil && password != "" else {
            isLoggedIn = false
            isSigningIn = true
            isSigningUp = true
            return
        }
        
        isLoggedIn = true
    }
    
    func deleteUserTapped() {
        UserDefaults.standard.removeObject(forKey: AppStorageKeys.username.rawValue)
        
        let keychain = KeychainSwift()
        keychain.delete(AppStorageKeys.password.rawValue)
        keychain.clear() // for paranoia
        
        password = nil
        username = nil
        isLoggedIn = false
        isSigningIn = true
        isSigningUp = true
    }
    
    func signOutTapped() {
        isLoggedIn = false
        isSigningIn = true
        isSigningUp = true
    }
    

    //@TODO: refactor this, too many if conditions
    var body: some View {
        NavigationView  {
            VStack {
                if isLoggedIn == false {
                    
                    if isSigningIn == true && isSigningUp == false {
                        SignInForm(username: $username, password: $password, isLoggedIn: $isLoggedIn)
                    } // signing in, not up
                    
                    if isSigningUp == true && isSigningIn == false {
                        SignUpForm(username: $username, password: $password, isLoggedIn: $isLoggedIn)
                    } // signing up, not in
                    
                    if isSigningUp == true && isSigningIn == true {
                        VStack {
                            Button("Sign up") {
                                isSigningIn = false
                                isSigningUp = true
                            }
                            Button("Sign in") {
                                isSigningIn = true
                                isSigningUp = false
                            }
                        } // VStack
                        .buttonStyle(OnboardingButtonStyle()) //@TODO: refactor styles globally
                        .padding()
                    }
                } // is not logged in
                
                if isLoggedIn == true {
                    if let username = UserDefaults.standard.object(forKey: AppStorageKeys.username.rawValue) as? String {
                        
                        Text("Hello, \(username)")
                    }
                    HStack {
                        Button("Sign out") {
                            signOutTapped()
                        }
                        Button("Delete account") {
                            deleteUserTapped()
                        }
                    } // HStack
                    .padding()
                    .buttonStyle(OnboardingButtonStyle()) //@TODO: refactor styles globally
                } // is logged in
            } // VStack
            .navigationTitle("Your profile")
            .onAppear {
                onAppear()
            }
        } // NavigationView
    }
}

struct SignUpForm: View { // @TODO: add more fields to create profile
    @Binding var username: String?
    @Binding var password: String?
    @Binding var isLoggedIn: Bool
    
    func createUserTapped() {
        let keychain = KeychainSwift()
        keychain.set(password!, forKey: AppStorageKeys.password.rawValue)
        
        UserDefaults.standard.setValue(username, forKey: AppStorageKeys.username.rawValue)
        isLoggedIn = true
    }
    
    var body: some View {
        Form {
            UsernameField(username: $username)
            PasswordField(password:
                Binding(
                    get: {
                        if let password = password {
                            return password
                        }
                        return "" // @TODO: why?? not secure, right?
                    },
                    set: {value, transaction in
                        password = value
                    }
                ) // Binding text
            )
        } // Form
        Button("Sign up") {
            createUserTapped()
        }.buttonStyle(OnboardingButtonStyle()) //@TODO: refactor styles globally
    }
}

struct SignInForm: View {
    @Binding var username: String?
    @Binding var password: String?
    @Binding var isLoggedIn: Bool
    
    func signInTapped() { // @TODO: alert the user when the input doesnt match
        guard let enteredUsername = username, !enteredUsername.isEmpty else {
            isLoggedIn = false
            return
        }
            
        guard let enteredPassword = password, !enteredPassword.isEmpty else {
            isLoggedIn = false
            return
        }
            
        if let storedUsername = UserDefaults.standard.string(forKey: AppStorageKeys.username.rawValue),
            let storedPassword = KeychainSwift().get(AppStorageKeys.password.rawValue) {
            
                if enteredUsername == storedUsername && enteredPassword == storedPassword {
                    isLoggedIn = true
                } else {
                    isLoggedIn = false
                }
            
        } else {
            isLoggedIn = false
        }
    }
    
    var body: some View {
        Form {
            UsernameField(username: $username)
            PasswordField(password:
                Binding(
                    get: {
                        if let password = password {
                            return password
                        }
                        return "" // @TODO: why?? not secure, right?
                    },
                    set: {value, transaction in
                        password = value
                    }
                ) // Binding text
            )
        } // Form
        Button("Sign in") {
            signInTapped()
        }.buttonStyle(OnboardingButtonStyle()) //@TODO: refactor styles globally
    }
}

struct UsernameField: View {
    @Binding var username: String?
    
    var body: some View {
        TextField("Username", text:
            Binding(
                get: {
                    if let username = username {
                        return username
                    }
                    return ""
                },
                set: {value, transaction in
                    username = value
                }
            ) // Binding
        ) // TextField
        .autocorrectionDisabled(true)
        .textInputAutocapitalization(.never)
    }
}

struct PasswordField: View {
    @State var isShowingPassword: Bool = false
    @FocusState var isFieldFocus: FieldToFocus?
    var password: Binding<String>
    
    var body: some View {
        HStack {
            Group {
                if isShowingPassword {
                    TextField("Password", text: password)
                    .focused($isFieldFocus, equals: .textField)
                } else {
                    SecureField("Password", text: password)
                    .focused($isFieldFocus, equals: .secureField)
                }
            } // Group
            .disableAutocorrection(true)
            .autocapitalization(.none)
            
            Button {
                isShowingPassword.toggle()
            } label: {
                if isShowingPassword {
                    Image(systemName: "eye.slash.fill")
                } else {
                    Image(systemName: "eye.fill")
                }
            }
        } // HStack for password field
        .onChange(of: isShowingPassword) { result in
            isFieldFocus = isShowingPassword ? .textField : .secureField
        }
    }
}

enum FieldToFocus {
    case secureField, textField
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
