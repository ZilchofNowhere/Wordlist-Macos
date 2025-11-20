//
//  Word.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import Combine

class Word: Identifiable, ObservableObject {
    let id = UUID()
    @Published var german: String
    @Published var english: String
    @Published var grammaticalType: GrammaticalType
    @Published var vocabTag: [VocabTag]?
    @Published var notes: String?
    @Published var exampleSentence: String?
    
    init(german: String, english: String, grammaticalType: GrammaticalType, vocabTag: [VocabTag]? = nil, notes: String? = nil, exampleSentence: String? = nil) {
        self.german = german
        self.english = english
        self.grammaticalType = grammaticalType
        self.vocabTag = vocabTag
        self.notes = notes
        self.exampleSentence = exampleSentence
    }
}

class Noun: Word {
    @Published var gender: Gender
    @Published var pluralForm: String?
    var article: String {
        switch gender {
            case .feminine: return "die"
            case .masculine: return "der"
            case .neuter: return "das"
            case .plural: return "die"
        }
    }
    
    init(german: String, english: String, vocabTag: [VocabTag]? = nil, notes: String? = nil, exampleSentence: String? = nil, gender: Gender, pluralForm: String?) {
        self.gender = gender
        self.pluralForm = pluralForm
        super.init(german: german, english: english, grammaticalType: .noun, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence)
    }
}

class Verb: Word {
    @Published var isRegular: Bool
    @Published var isSeparable: Bool
    @Published var present: String?
    @Published var imperfect: String?
    @Published var pastParticiple: String?
    @Published var auxiliary: String
    
    init(german: String, english: String, vocabTag: [VocabTag]? = nil, notes: String? = nil, exampleSentence: String? = nil, isRegular: Bool = true, isSeparable: Bool = false, present: String? = nil, imperfect: String? = nil, pastParticiple: String? = nil, auxiliary: String = "haben") {
        self.isRegular = isRegular
        self.isSeparable = isSeparable
        self.present = present
        self.imperfect = imperfect
        self.pastParticiple = pastParticiple
        self.auxiliary = auxiliary
        super.init(german: german, english: english, grammaticalType: .verb, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence)
    }
}

class Adjective: Word {
    @Published var isRegular: Bool
    @Published var comparativeForm: String?
    
    init(german: String, english: String, vocabTag: [VocabTag]? = nil, notes: String? = nil, exampleSentence: String? = nil, isRegular: Bool = true, comparativeForm: String? = nil) {
        self.isRegular = isRegular
        self.comparativeForm = comparativeForm
        super.init(german: german, english: english, grammaticalType: .adjective, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence)
    }
}

class Preposition: Word {
    @Published var nounCase: String
    
    init(german: String, english: String, vocabTag: [VocabTag]? = nil, notes: String? = nil, exampleSentence: String? = nil, nounCase: String) {
        self.nounCase = nounCase
        super.init(german: german, english: english, grammaticalType: .preposition, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence)
    }
}
