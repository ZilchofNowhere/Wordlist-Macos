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
    var body: some Scene {
        Window("Wordlist", id: "main") {
            ContentView()
        }
        .modelContainer(for: Word.self)
        .commands {
            CommandGroup(replacing: .importExport) {
                Button {
                    
                } label: {
                    Label("Import...", systemImage: "square.and.arrow.down")
                }
                Button {
                    
                } label: {
                    Label("Export...", systemImage: "square.and.arrow.up")
                }
            }
            SidebarCommands()
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }
}
