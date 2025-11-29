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
    
    func toCSV() -> String {
        // schema: german,english,type,gender,pluralForm,isRegular,isSeparable,present,imperfect,pastParticiple,auxiliary,comparativeForm,nounCase,vocabTag,exampleSentence,notes
        var tags = ""
        for tag in vocabTag {
            tags.append("\(tag.rawValue),")
        }
        return switch type {
            case .noun:
                "\(german),\(english),\(type),\(gender?.rawValue ?? ""),\(pluralForm ?? ""),,,,,,,,,\(tags),\(exampleSentence ?? ""),\(notes ?? "")"
            case .verb:
                "\(german),\(english),\(type),,,\(isRegular),\(isSeparable),\(present ?? ""),\(imperfect ?? ""),\(pastParticiple ?? ""),\(auxiliary),,,\(tags),\(exampleSentence ?? ""),\(notes ?? "")"
            case .adjective:
                "\(german),\(english),\(type),,,\(isRegular),,,,,,\(comparativeForm ?? ""),,\(tags),\(exampleSentence ?? ""),\(notes ?? "")"
            case .preposition:
                "\(german),\(english),\(type),,,,,,,,,,\(nounCase ?? ""),\(tags),\(exampleSentence ?? ""),\(notes ?? "")"
            default:
                "\(german),\(english),\(type),,,,,,,,,,,\(tags),\(exampleSentence ?? ""),\(notes ?? "")"
        }
    }
}

extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
    }
}

func searchWord(_ word: Word, for query: String) -> Bool {
    let wordSpecificCheck = switch word.type {
        case .noun:
             ((word.pluralForm?.localizedStandardContains(query)) != nil) || word.gender!.rawValue.localizedStandardContains(query)
        case .verb:
            if (!word.isRegular) {
                word.present!.localizedStandardContains(query) || word.imperfect!.localizedStandardContains(query) || word.pastParticiple!.localizedStandardContains(query)
            } else {
                false
            }
        case .adjective:
            if (!word.isRegular) {
                word.comparativeForm!.localizedStandardContains(query)
            } else {
                false
            }
        default:
            false
    }
    
    var tagCheck = false
    for tag in word.vocabTag {
        if (tag.rawValue.localizedStandardContains(query)) {
            tagCheck = true
            break
        }
    }
    
    return wordSpecificCheck || tagCheck || word.german.localizedStandardContains(query) || word.english.localizedStandardContains(query)
}

func exportToCSV() {
    
}

func readCSV(data: String) {
    
}
