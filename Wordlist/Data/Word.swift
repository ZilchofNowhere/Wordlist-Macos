//
//  Word.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData

@Model
final class Word: Identifiable {
    @Attribute(.unique) var id = UUID()
    var german: String
    var english: String
    var type: GrammaticalType
    var vocabTag: [VocabTag]
    var notes: String?
    var exampleSentence: String?
    @Attribute(.externalStorage) var imageData: Data?
    
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
    var auxiliary: String?
    
    // adj
    var comparativeForm: String?
    
    // prep
    var nounCase: String?
    
    init(german: String, english: String, type: GrammaticalType, vocabTag: [VocabTag] = [], notes: String? = nil, exampleSentence: String? = nil, gender: Gender? = nil, pluralForm: String? = nil, isRegular: Bool = true, isSeparable: Bool = false, present: String? = nil, imperfect: String? = nil, pastParticiple: String? = nil, auxiliary: String? = "haben", comparativeForm: String? = nil, nounCase: String? = nil, imageData: Data? = nil) {
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
        self.imageData = imageData
    }
        
    func toCSV() -> String {
        // schema: german,"english",type,gender,pluralForm,isRegular,isSeparable,present,imperfect,pastParticiple,auxiliary,comparativeForm,nounCase,"exampleSentence","notes",vocabTag
        var tags = ""
        for tag in vocabTag {
            tags.append("\(tag.rawValue),")
        }
        return switch type {
            case .noun:
                "\(german),\"\(english)\",\(type.rawValue),\(gender?.rawValue ?? ""),\(pluralForm ?? ""),,,,,,,,,\"\(exampleSentence ?? "")\",\"\(notes ?? "")\",\"\(tags)\""
            case .verb:
                "\(german),\"\(english)\",\(type.rawValue),,,\(isRegular),\(isSeparable),\(present ?? ""),\(imperfect ?? ""),\(pastParticiple ?? ""),\(auxiliary ?? "haben"),,,\"\(exampleSentence ?? "")\",\"\(notes ?? "")\",\"\(tags)\""
            case .adjective:
                "\(german),\"\(english)\",\(type.rawValue),,,\(isRegular),,,,,,\(comparativeForm ?? ""),,\"\(exampleSentence ?? "")\",\"\(notes ?? "")\",\"\(tags)\""
            case .preposition:
                "\(german),\"\(english)\",\(type.rawValue),,,,,,,,,,\(nounCase ?? ""),\"\(exampleSentence ?? "")\",\"\(notes ?? "")\",\"\(tags)\""
            default:
                "\(german),\"\(english)\",\(type.rawValue),,,,,,,,,,,\"\(exampleSentence ?? "")\",\"\(notes ?? "")\",\"\(tags)\""
        }
    }
}

extension Word: Equatable {
    static func == (lhs: Word, rhs: Word) -> Bool {
        lhs.id == rhs.id
    }
}
