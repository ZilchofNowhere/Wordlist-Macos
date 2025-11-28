//
//  MockWords.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

private let wordlist = [
    Word(german: "Auto", english: "car", type: .noun, gender: .neuter, pluralForm: "Autos"),
    Word(german: "laufen", english: "to walk", type: .verb, isRegular: false, present: "läuft", imperfect: "lief", pastParticiple: "gelaufen", auxiliary: "sein"),
    Word(german: "lang", english: "long", type: .adjective, isRegular: false, comparativeForm: "länger"),
    Word(german: "Haus", english: "house", type: .noun, vocabTag: [.house], gender: .neuter, pluralForm: "Häuser"),
    Word(german: "Kuh", english: "cow", type: .noun, vocabTag: [.animal], gender: .feminine, pluralForm: "Kühe"),
    Word(german: "Stadt", english: "city", type: .noun, vocabTag: [.city], gender: .feminine, pluralForm: "Städte"),
    Word(german: "heiraten", english: "to marry", type: .verb, vocabTag: [.family])
]
