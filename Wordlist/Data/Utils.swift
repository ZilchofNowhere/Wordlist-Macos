//
//  Utils.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 29.11.2025.
//

import SwiftUI
import SwiftData

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
