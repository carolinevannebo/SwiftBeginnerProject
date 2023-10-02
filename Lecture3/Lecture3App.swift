//
//  Lecture3App.swift
//  Lecture3
//
//  Created by Caroline Vannebo on 04/09/2023.
//

import SwiftUI

@main
struct Lecture3App: App { // @TODO: rename project, lol
    var body: some Scene {
        WindowGroup {
            TabView {
                ContactListView()
                    .tabItem {
                        Label("Contacts", systemImage: "book")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.crop.circle")
                    }
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }
            } // TabView
        } // WindowGroup
    } // Scene
}
