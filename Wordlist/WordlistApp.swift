//
//  WordlistApp.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI

@main
struct WordlistApp: App {
    @StateObject var store = WordStore()
    @Environment(\.openWindow) var openWindow

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About Wordlist") {
                    openWindow(id: "about-app")
                }
            }
        }
        Window("About Wordlist", id: "about-app") {
            AboutView()
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }
}
