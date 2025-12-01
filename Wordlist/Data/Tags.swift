//
//  Tags.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

enum GrammaticalType: String, CaseIterable, Identifiable, Hashable, Codable {
    case noun = "Noun"
    case verb = "Verb"
    case adjective = "Adjective"
    case adverb = "Adverb"
    case pronoun = "Pronoun"
    case preposition = "Preposition"
    case conjunction = "Conjunction"
    case interjection = "Interjection"
    
    var id: Self { self }
}

enum Gender: String, CaseIterable, Identifiable, Hashable, Codable {
    case masculine = "Masculine"
    case feminine = "Feminine"
    case neuter = "Neuter"
    case plural = "Plural"
    
    var id: Self { self }
}

enum VocabTag: String, CaseIterable, Identifiable, Hashable, Codable {
    case animal = "Animal"
    case food = "Food"
    case sport = "Sport"
    case school = "School"
    case technology = "Technology"
    case plant = "Plant"
    case house = "House"
    case health = "Health"
    case city = "City"
    case family = "Family"
    case job = "Job"
    case science = "Science"
    case emotion = "Emotion and Personality"
    case travel = "Travel"
    case art = "Art"
    
    var id: Self { self }
}
