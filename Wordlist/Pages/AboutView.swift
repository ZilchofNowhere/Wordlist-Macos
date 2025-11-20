//
//  AboutView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//


import SwiftUI

struct AboutView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(nsImage: NSApp.applicationIconImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 72, height: 72)
                .cornerRadius(16)

            Text("Wordlist")
                .font(.title2)
                .bold()

            Text("Version \(appVersion) (\(buildNumber))")
                .foregroundColor(.secondary)

            Text("© 2025 Zilch of Nowhere")
                .font(.footnote)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(width: 350, height: 200)
    }

    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }

    var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
    }
}
