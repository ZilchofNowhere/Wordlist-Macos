//
//  VocabTagChips.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 28.11.2025.
//

import SwiftUI

struct VocabTagChips: View {
    @Binding var selection: [VocabTag]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(VocabTag.allCases, id: \.self) { scope in
                    Button {
                        if selection.contains(scope) {
                            selection.removeAll { $0 == scope }
                        } else {
                            selection.append(scope)
                        }
                    } label: {
                        Text(scope.rawValue)
                            .fontWeight(selection.contains(scope) ? .semibold : .regular)
                    }
                    // Native macOS "Filter" button look
                    .buttonStyle(.borderedProminent)
                    // Only color it if selected, otherwise make it gray/clear
                    .tint(selection.contains(scope) ? .accentColor : .gray.opacity(0.2))
                    .buttonBorderShape(.capsule) // 👈 Makes it round like a Chip
                    .controlSize(.small)
                }
            }
            .padding(.bottom, 8)
        }
    }
}
