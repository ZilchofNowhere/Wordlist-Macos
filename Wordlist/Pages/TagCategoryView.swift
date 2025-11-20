//
//  TagsView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//


import SwiftUI

struct TagCategoryView: View {
    @EnvironmentObject var store: WordStore
    let category: GrammaticalType
    @Binding var selectedWordId: UUID?
    
    var wordset: [Word] {
        switch category {
            case .noun: return store.nouns
            case .adjective: return store.adjectives
            case .verb: return store.verbs
            case .adverb: return store.adverbs
            case .preposition: return store.prepositions
            case .pronoun: return store.pronouns
            case .conjunction: return store.conjunctions
            case .interjection: return store.interjections
        }
    }

    var body: some View {
        if (wordset.count != 0) {
            List(selection: $selectedWordId) {
                ForEach(wordset) { word in
                    WordCard(word: word, isSelected: selectedWordId == word.id).tag(word.id)
                }
            }
        } else {
            Text("No words in this category. 🫠")
                .font(.largeTitle)
        }
    }
}
