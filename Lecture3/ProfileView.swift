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

enum FieldToFocus {
    case secureField, textField
}

// @TODO: require more information for new account, ask to repeat password before creating
struct ProfileView: View {
    @State var username: String?
    @State var password: String?
    
    @State var isLoggedIn: Bool = false
    @State var isSigningUp: Bool = false
    @State var isSigningIn: Bool = false
    
    @State var isShowingErrorAlert: Bool = false
    @State var errorMessage: String = ""
    
    @State var hasTappedSignOut: Bool = false
    
    func onAppearOld() { //@TODO: refactor this redundant shit
        if let username = UserDefaults.standard.object(forKey: AppStorageKeys.username.rawValue) as? String {
            self.username = username
        }
        
        let keychain = KeychainSwift()
        if let password = keychain.get(AppStorageKeys.password.rawValue) {
            self.password = password
        }
        
        guard let usernameRef = username, !usernameRef.isEmpty else {
            isLoggedIn = false
            isSigningIn = true
            isSigningUp = true
            return
        }
        
        guard username != nil && username != "" else {
            isLoggedIn = false
            isSigningIn = true
            isSigningUp = true
            return
        }
        
        guard let passwordRef = password, !passwordRef.isEmpty else {
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
    
    func onAppear() { //@TODO: test this function after refactoring
        if hasTappedSignOut == true { return }
        
        if let username = UserDefaults.standard.object(forKey: AppStorageKeys.username.rawValue) as? String,
           let password = KeychainSwift().get(AppStorageKeys.password.rawValue),
           !username.isEmpty && !password.isEmpty {
            isLoggedIn = true
        } else {
            isLoggedIn = false
            isSigningIn = true
            isSigningUp = true
        }
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
        hasTappedSignOut = true
    }
    

    //@TODO: refactor this, too many if conditions
    var body: some View {
        NavigationView  {
            VStack {
                if isLoggedIn == false {
                    
                    if isSigningIn == true && isSigningUp == false {
                        SignInForm(username: $username, password: $password, isLoggedIn: $isLoggedIn, isShowingErrorAlert: $isShowingErrorAlert, errorMessage: $errorMessage, hasTappedSignOut: $hasTappedSignOut)
                    } // signing in, not up
                    
                    if isSigningUp == true && isSigningIn == false {
                        SignUpForm(username: $username, password: $password, isLoggedIn: $isLoggedIn, isShowingErrorAlert: $isShowingErrorAlert, errorMessage: $errorMessage, hasTappedSignOut: $hasTappedSignOut)
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
        .alert("Oops! An error occured", isPresented: $isShowingErrorAlert) {
            Text("Some actions")
        } message: {
            Text($errorMessage.wrappedValue)
        }
    }
}

struct SignUpForm: View { // @TODO: add more fields to create profile
    @Binding var username: String?
    @Binding var password: String?
    @Binding var isLoggedIn: Bool
    @Binding var isShowingErrorAlert: Bool
    @Binding var errorMessage: String
    @Binding var hasTappedSignOut: Bool
    
    func createUserTapped() {
        if password == nil || password == "" { // Avoid runtime error
            errorMessage = "Password can not be empty."
            isShowingErrorAlert = true
            return
        }
        
        let keychain = KeychainSwift()
        keychain.set(password!, forKey: AppStorageKeys.password.rawValue)
        
        if username == nil || username == "" {
            errorMessage = "Username can not be empty."
            isShowingErrorAlert = true
            return
        }
        
        UserDefaults.standard.setValue(username, forKey: AppStorageKeys.username.rawValue)
        isLoggedIn = true
        hasTappedSignOut = false
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
    
    @Binding var isShowingErrorAlert: Bool
    @Binding var errorMessage: String
    
    @Binding var hasTappedSignOut: Bool
    
    func signInTapped() { // @TODO: alert the user when the input doesnt match
        guard let enteredUsername = username, !enteredUsername.isEmpty else {
            errorMessage = "Please enter username."
            isShowingErrorAlert = true
            isLoggedIn = false
            return
        }
            
        guard let enteredPassword = password, !enteredPassword.isEmpty else {
            errorMessage = "Please enter password."
            isShowingErrorAlert = true
            isLoggedIn = false
            return
        }
            
        if let storedUsername = UserDefaults.standard.string(forKey: AppStorageKeys.username.rawValue),
            let storedPassword = KeychainSwift().get(AppStorageKeys.password.rawValue) {
            
            if enteredUsername == storedUsername && enteredPassword == storedPassword {
                isLoggedIn = true
                hasTappedSignOut = false
            } else {
                isLoggedIn = false
            }
            
        } else { // wait what
            errorMessage = "Incorrect log in credentials, try again."
            isShowingErrorAlert = true
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
