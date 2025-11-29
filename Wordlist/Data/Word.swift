//
//  Word.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData
import Combine

@Model
final class Word: Identifiable {
    @Attribute(.unique) var id = UUID()
    var german: String
    var english: String
    var type: GrammaticalType
    var vocabTag: [VocabTag]
    var notes: String?
    var exampleSentence: String?
    
    // noun
    var gender: Gender?
    var pluralForm: String?
    var article: String {
        switch gender {
            case .feminine: return "die"
            case .masculine: return "der"
            case .neuter: return "das"
            case .plural: return "die"
            default: return ""
        }
    }
    
    // verb
    var isRegular: Bool // also for adj
    var isSeparable: Bool
    var present: String?
    var imperfect: String?
    var pastParticiple: String?
    var auxiliary: String
    
    // adj
    var comparativeForm: String?
    
    // prep
    var nounCase: String?
    
    init(german: String, english: String, type: GrammaticalType, vocabTag: [VocabTag] = [], notes: String? = nil, exampleSentence: String? = nil, gender: Gender? = nil, pluralForm: String? = nil, isRegular: Bool = true, isSeparable: Bool = false, present: String? = nil, imperfect: String? = nil, pastParticiple: String? = nil, auxiliary: String = "haben", comparativeForm: String? = nil, nounCase: String? = nil) {
        self.german = german
        self.english = english
        self.type = type
        self.gender = gender
        self.pluralForm = pluralForm
        self.isRegular = isRegular
        self.isSeparable = isSeparable
        self.present = present
        self.imperfect = imperfect
        self.pastParticiple = pastParticiple
        self.auxiliary = auxiliary
        self.comparativeForm = comparativeForm
        self.nounCase = nounCase
        self.vocabTag = vocabTag
        self.exampleSentence = exampleSentence
        self.notes = notes
    }
    
    init(data: String) {
        let keys = data.split(separator: ",", omittingEmptySubsequences: false)
        // global properties
        self.german = String(keys[0])
        self.english = String(keys[1])
        self.type = switch keys[2] {
            case "Noun":
                .noun
            case "Verb":
                .verb
            case "Adjective":
                .adjective
            case "Preposition":
                .preposition
            case "Adverb":
                .adverb
            case "Conjunction":
                .conjunction
            case "Pronoun":
                .pronoun
            case "Interjection":
                .interjection
            default:
                .noun
        }
        self.exampleSentence = String(keys[13])
        self.notes = String(keys[14])
        var tTags: [VocabTag] = []
        let vocab = keys[15...]
        
        for tag in vocab {
            tTags.append(.init(rawValue: String(tag))!)
        }
        self.vocabTag = tTags
        
        // noun
        self.gender = switch keys[3] {
            case "Masculine":
                    .masculine
            case "Feminine":
                    .feminine
            case "Neuter":
                    .neuter
            case "Plural":
                    .plural
            default:
                nil
        }
        self.pluralForm = String(keys[4])
        
        // verb
        self.isRegular = String(keys[5]) == "true"
        self.isSeparable = String(keys[6]) == "true"
        self.present = String(keys[7])
        self.imperfect = String(keys[8])
        self.pastParticiple = String(keys[9])
        self.auxiliary = String(keys[10])
        
        // adj
        self.comparativeForm = String(keys[11])
        
        // prep
        self.nounCase = String(keys[12])
    }
    
    func toCSV() -> String {
        // schema: german,english,type,gender,pluralForm,isRegular,isSeparable,present,imperfect,pastParticiple,auxiliary,comparativeForm,nounCase,exampleSentence,notes,vocabTag
        var tags = ""
        for tag in vocabTag {
            tags.append("\(tag.rawValue),")
        }
        return switch type {
            case .noun:
                "\(german),\(english),\(type),\(gender?.rawValue ?? ""),\(pluralForm ?? ""),,,,,,,,,\(exampleSentence ?? ""),\(notes ?? ""),\(tags)"
            case .verb:
                "\(german),\(english),\(type),,,\(isRegular),\(isSeparable),\(present ?? ""),\(imperfect ?? ""),\(pastParticiple ?? ""),\(auxiliary),,,\(exampleSentence ?? ""),\(notes ?? ""),\(tags)"
            case .adjective:
                "\(german),\(english),\(type),,,\(isRegular),,,,,,\(comparativeForm ?? ""),,\(exampleSentence ?? ""),\(notes ?? ""),\(tags)"
            case .preposition:
                "\(german),\(english),\(type),,,,,,,,,,\(nounCase ?? ""),\(exampleSentence ?? ""),\(notes ?? ""),\(tags)"
            default:
                "\(german),\(english),\(type),,,,,,,,,,,\(exampleSentence ?? ""),\(notes ?? ""),\(tags)"
        }
    }
}

extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
    }
}
