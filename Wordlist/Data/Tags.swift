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
    case clothing = "Clothing"
    case law = "Law"
    
    var id: Self { self }
}

var allVocabTags: [VocabularyTag] = [
    .init(name: "Animal", icon: "pawprint"),
    .init(name: "Food", icon: "fork.knife"),
    .init(name: "Sport", icon: "soccerball.inverse"),
    .init(name: "School", icon: "book"),
    .init(name: "Technology", icon: "bolt"),
    .init(name: "Plant", icon: "leaf"),
    .init(name: "House", icon: "house"),
    .init(name: "Health", icon: "stethoscope"),
    .init(name: "City", icon: "building.2"),
    .init(name: "Family", icon: "figure.2.and.child.holdinghands"),
    .init(name: "Job", icon: "briefcase"),
    .init(name: "Science", icon: "flask"),
    .init(name: "Emotion and Personality", icon: "face.smiling"),
    .init(name: "Travel", icon: "airplane.up.right"),
    .init(name: "Art", icon: "paintpalette"),
    .init(name: "Clothing", icon: "tshirt"),
    .init(name: "Law", icon: "building.columns")
]
