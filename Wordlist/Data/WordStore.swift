//
//  WordStore.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import Combine

class WordStore: ObservableObject {
    @Published var words: [Word] = []
    
    init() {
        loadSampleData()
    }
}

extension WordStore {
    func addWord(_ word: Word) {
        words.append(word)
    }
    
    func delete(_ word: Word) {
        words.removeAll { $0.id == word.id }
    }
    
    var all: [Word] {
        words
    }
    
    var nouns: [Noun] {
        words.compactMap { $0 as? Noun }
    }
    
    var verbs: [Verb] {
        words.compactMap { $0 as? Verb }
    }
    
    var adjectives: [Adjective] {
        words.compactMap { $0 as? Adjective }
    }
    
    var prepositions: [Preposition] {
        words.compactMap { $0 as? Preposition }
    }
    
    var adverbs: [Word] {
        words.filter { $0.grammaticalType == .adverb }
    }
    
    var pronouns: [Word] {
        words.filter { $0.grammaticalType == .pronoun}
    }
    
    var conjunctions: [Word] {
        words.filter { $0.grammaticalType == .conjunction}
    }
    
    var interjections: [Word] {
        words.filter { $0.grammaticalType == .interjection}
    }
}
