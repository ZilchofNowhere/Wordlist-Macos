//
//  MockWords.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

private let wordlist = [
    Noun(german: "Auto", english: "car", gender: .neuter, pluralForm: "Autos"),
    Verb(german: "laufen", english: "to walk", isRegular: false, present: "läuft", imperfect: "lief", pastParticiple: "gelaufen", auxiliary: "sein"),
    Adjective(german: "lang", english: "long", isRegular: false, comparativeForm: "länger"),
    Noun(german: "Haus", english: "house", gender: .neuter, pluralForm: "Häuser"),
    Noun(german: "Kuh", english: "cow", vocabTag: [.animal], gender: .feminine, pluralForm: "Kühe"),
    Noun(german: "Stadt", english: "city", gender: .feminine, pluralForm: "Städte"),
    Verb(german: "heiraten", english: "to marry")
]

extension WordStore {
    func loadSampleData() {
        for word in wordlist {
            self.addWord(word)
        }
    }
}
