//
//  Word.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

class Word {
    let german: String
    let english: String
    let grammaticalType: GrammaticalType
    let vocabTag: [VocabTag]
    let notes: String?
    
    init(german: String, english: String, grammaticalType: GrammaticalType, vocabTag: [VocabTag], notes: String?) {
        self.german = german
        self.english = english
        self.grammaticalType = grammaticalType
        self.vocabTag = vocabTag
        self.notes = notes
    }
}

class Noun: Word {
    let gender: Gender
    let pluralForm: String?
    var article: String {
        switch gender {
            case .feminine: return "die"
            case .masculine: return "der"
            case .neuter: return "das"
            case .plural: return "die"
        }
    }
    
    init(german: String, english: String, vocabTag: [VocabTag], notes: String?, gender: Gender, pluralForm: String?) {
        self.gender = gender
        self.pluralForm = pluralForm
        super.init(german: german, english: english, grammaticalType: .noun, vocabTag: vocabTag, notes: notes)
    }
}

class Verb: Word {
    let isRegular: Bool
    let isSeparable: Bool
    let present: String?
    let imperfect: String?
    let pastParticiple: String?
    
    init(german: String, english: String, vocabTag: [VocabTag], notes: String?, isRegular: Bool = true, isSeparable: Bool = true, present: String?, imperfect: String?, pastParticiple: String?) {
        self.isRegular = isRegular
        self.isSeparable = isSeparable
        self.present = present
        self.imperfect = imperfect
        self.pastParticiple = pastParticiple
        super.init(german: german, english: english, grammaticalType: .verb, vocabTag: vocabTag, notes: notes)
    }
}

class Adjective: Word {
    var comparativeForm: String?
    
    init(german: String, english: String, vocabTag: [VocabTag], notes: String?, comparativeForm: String? = nil) {
        self.comparativeForm = comparativeForm
        super.init(german: german, english: english, grammaticalType: .adjective, vocabTag: vocabTag, notes: notes)
    }
}

