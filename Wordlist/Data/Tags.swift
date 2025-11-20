//
//  Tags.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

enum GrammaticalType: String, CaseIterable, Identifiable, Hashable {
    case noun = "Noun"
    case verb = "Verb"
    case adjective = "Adjective"
    case adverb = "Adverb"
    case pronoun = "Pronoun"
    case preposition = "Preposition"
    case conjunction = "Conjunction"
    case interjection = "Interjection"
    
    var id: String {
        switch self {
            case .noun: return "Noun"
            case .verb: return "Verb"
            case .adjective: return "Adjective"
            case .adverb: return "Adverb"
            case .pronoun: return "Pronoun"
            case .preposition: return "Preposition"
            case .conjunction: return "Conjunction"
            case .interjection: return "Interjection"
        }
    }
}

enum Gender: String, CaseIterable, Identifiable, Hashable {
    case masculine = "Masculine"
    case feminine = "Feminine"
    case neuter = "Neuter"
    case plural = "Plural"
    
    var id: String {
        switch self {
            case .masculine: return "Masculine"
            case .feminine: return "Feminine"
            case .neuter: return "Neuter"
            case .plural: return "Plural"
        }
    }
}

// will also have vocab categories like animals, school objects, etc. as tags
enum VocabTag: String, CaseIterable, Identifiable, Hashable {
    case animal = "Animal"
    case food = "Food"
    case sport = "Sport"
    case school = "School"
    case technology = "Technology"
    case plant = "Plant"
    
    var id: String {
        switch self {
            case .animal: return "Animal"
            case .food: return "Food"
            case .sport: return "Sport"
            case .school: return "School"
            case .technology: return "Technology"
            case .plant: return "Plant"
        }
    }
}
