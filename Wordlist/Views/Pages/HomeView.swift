//
//  HomeView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//


import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @Binding var selectedWordId: UUID?
    @Binding var sortMode: SortMode
    
    @Query private var words: [Word]
    
    init(filterString: String, selectedWordId: Binding<UUID?>, sortMode: Binding<SortMode>) {
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
            SortDescriptor(\Word.german, comparator: .localizedStandard, order: .forward)
        ])
    }
    
    var body: some View {
        List(selection: $selectedWordId) {
            ForEach(words) { word in
                WordCard(word: word, isSelected: selectedWordId == word.id).tag(word.id)
            }
        }
    }
}
