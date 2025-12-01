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
    
    @Query private var words: [Word]
    
    init(filterString: String, selectedWordId: Binding<UUID?>) {
        _selectedWordId = selectedWordId
        
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
            SortDescriptor(\Word.german, comparator: .localizedStandard)
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
