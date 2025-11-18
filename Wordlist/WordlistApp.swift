//
//  WordlistApp.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI

@main
struct WordlistApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        Window("About Wordlist", id: "about") {
            AboutView()
                .frame(width: 350, height: 200)
        }
    }
}
