//
//  WordCard.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData

struct WordCard: View {
    @Environment(\.modelContext) private var modelContext
    var word: Word
    var isSelected: Bool
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.clear)
            
            VStack {
                if word.type == .noun {
                    Text(verbatim: { () -> String in
                        var base = "\(word.article) \(word.german)"
                        if let plural = word.pluralForm, !plural.isEmpty {
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
        .contextMenu {
            Button {
                modelContext.insert(word)
            } label: {
                Label("Duplicate", systemImage: "document.on.document")
            }
            
            Button(role: .destructive) {
                modelContext.delete(word)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .frame(height: 150)
    }
}

#Preview {
    WordCard(word: Word(german: "Kuh", english: "cow", type: .noun, vocabTag: [.animal], gender: .feminine, pluralForm: "Kühe"), isSelected: false)
}
