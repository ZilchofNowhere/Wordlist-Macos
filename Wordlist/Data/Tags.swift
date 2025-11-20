//
//  Tags.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

enum GrammaticalType: String, CaseIterable {
    case noun = "Noun"
    case verb = "Verb"
    case adjective = "Adjective"
    case adverb = "Adverb"
    case pronoun = "Pronoun"
    case conjunction = "Conjunction"
    case preposition = "Preposition"
    case interjection = "Interjection"
}

enum Gender: String, CaseIterable {
    case masculine = "Masculine"
    case feminine = "Feminine"
    case neuter = "Neuter"
    case plural = "Plural"
}

// will also have vocab categories like animals, school objects, etc. as tags
enum VocabTag: String, CaseIterable {
    case animal = "Animal"
    case food = "Food"
    case sport = "Sport"
    case school = "School"
    case technology = "Technology"
    case plant = "Plant"
}
