//
//  VocabCategoryView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 1.12.2025.
//

import SwiftUI
import SwiftData

struct VocabCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    let category: VocabTag
    
    @Query private var words: [Word]
    @Binding var selectedWordId: UUID?
    @Binding var sortMode: SortMode
    
    init(category: VocabTag, filterString: String, selectedWordId: Binding<UUID?>, sortMode: Binding<SortMode>) {
        self.category = category
        _selectedWordId = selectedWordId
        _sortMode = sortMode
        
        let predicate = #Predicate<Word> { word in
            if filterString.isEmpty {
                return true
            } else {
                return (
                    word.german.localizedStandardContains(filterString) ||
                    word.english.localizedStandardContains(filterString)
                )
            }
        }
        
        _words = Query(filter: predicate, sort: [
            sortMode.wrappedValue == .newerFirst ? SortDescriptor(\Word.timestamp, order: .reverse) : sortMode.wrappedValue == .olderFirst ? SortDescriptor(\Word.timestamp, order: .forward) : SortDescriptor(\Word.german, comparator: .localizedStandard),
            SortDescriptor(\Word.german, comparator: .localizedStandard)
        ])
    }
    
    var body: some View {
        if (words.filter { $0.vocabTag.contains(self.category) }.count > 0) {
            List(selection: $selectedWordId) {
                ForEach(words.filter { $0.vocabTag.contains(self.category) }) { word in
                    WordCard(word: word, isSelected: selectedWordId == word.id).tag(word.id)
                }
            }
            .navigationTitle(self.category.rawValue)
        } else {
            Text("No words in this category. 🫠")
                .font(.largeTitle)
                .navigationTitle(self.category.rawValue)
        }
    }
}
