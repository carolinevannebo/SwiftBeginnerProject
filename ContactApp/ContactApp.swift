//
//  ContactApp.swift
//  ContactApp
//
//  Created by Caroline Vannebo on 04/09/2023.
//

import SwiftUI

@main
struct ContactApp: App { // @TODO: check todos in ProfileView, create favorites tab with logic and start on settings
    var body: some Scene {
        WindowGroup {
            TabView {
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart")
                    }
                ContactListView(contacts: Contact.demoContacts, isAdmin: true)
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
            }
        }
    }
}
