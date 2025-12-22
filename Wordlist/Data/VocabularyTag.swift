//
//  VocabTag.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 12.12.2025.
//

import SwiftData

@Model
final class VocabularyTag: Identifiable {
    var name: String
    var icon: String = ""
    var iconIsEmoji = false
    
    @Relationship(deleteRule: .nullify)
    var words: [Word] = []
    
    init(name: String, icon: String = "", iconIsEmoji: Bool = false) {
        self.name = name
        self.icon = icon
        self.iconIsEmoji = iconIsEmoji
    }
}
