//
//  WordlistApp.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData

@main
struct WordlistApp: App {
    @Environment(\.openWindow) var openWindow

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Word.self)
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
