//
//  WordCard.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI

struct WordCard: View {
    var word: Word
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(.background)
            
            VStack {
                if let noun = word as? Noun {
                    Text(verbatim: { () -> String in
                        var base = "\(noun.article) \(noun.german)"
                        if let plural = noun.pluralForm, !plural.isEmpty {
                            base += ", \(plural)"
                        }
                        return base
                    }())
                    .font(.title2)
                    .foregroundStyle(.foreground)
                } else {
                    Text(word.german)
                        .font(.title2)
                        .foregroundStyle(.foreground)
                }

                Text(word.english)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                
            }
            .padding(20)
            .multilineTextAlignment(.center)
        }
        .frame(height: 150)
    }
}

