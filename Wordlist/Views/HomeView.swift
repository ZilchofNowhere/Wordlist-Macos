//
//  HomeView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//


import SwiftUI

struct HomeView: View {
    @EnvironmentObject var store: WordStore
    @Binding var selectedWordId: UUID?
    
    var body: some View {
        List(selection: $selectedWordId) {
            ForEach(store.all) { word in
                WordCard(word: word, isSelected: selectedWordId == word.id).tag(word.id)
            }
        }
    }
}
