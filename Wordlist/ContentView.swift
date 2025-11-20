//
//  ContentView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

enum SidebarItem: Hashable, Identifiable {
    case home
    case about
    case tag(GrammaticalType)
    case quiz

    var id: String {
        switch self {
            case .home: return "home"
            case .about: return "about"
            case .tag(let cat): return cat.rawValue
            case .quiz: return "quiz"
        }
    }
}

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: WordStore

    @State private var selection: SidebarItem? = .home
    @State private var query = ""
    @State private var selectedSegment = 0
    @State private var isAddWordViewOpen = false
    @State private var selectedWordId: UUID?

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
                .frame(minWidth: 180)
        } detail: {
            switch selection {
                case .home:
                    HomeView(selectedWordId: $selectedWordId)
                case .tag(let category):
                    TagCategoryView(category: category, selectedWordId: $selectedWordId)
                case .about:
                    AboutView()
                case .quiz:
                    QuizView()
                case .none:
                    Text("Select a page")
            }
        }
        .inspector(isPresented: Binding(
            get: { selectedWordId != nil }, // Show if something is selected
            set: { if !$0 { selectedWordId = nil } } // Deselect if closed
        )) {
            if let id = selectedWordId, let word = store.words.first(where: { $0.id == id }) {
                EditWordView(word: word)
                    .inspectorColumnWidth(min: 250, ideal: 300)
            } else {
                ContentUnavailableView("No Selection", systemImage: "cursorarrow.click")
                    .frame(minWidth: 250, idealWidth: 300)
            }
        }
        .inspector(isPresented: Binding(get: {isAddWordViewOpen && selectedWordId == nil}, set: { if !$0 {isAddWordViewOpen = false}})) {
            AddWordView()
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    isAddWordViewOpen.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .help("Add a new word")
            }
            ToolbarItem(placement: .automatic) {
                HStack {
                    TextField("Words…", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 200)
                    
                    // 2) FILTER BUTTON
                    Button {
                        // filter by word or by tag
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                    .help("Filter")
                }
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    if selectedWordId != nil {
                        $selectedWordId.wrappedValue = nil
                    }
                } label: {
                    Image(systemName: "sidebar.right")
                }
                .help("Hide the sidebar")
            }
        }
        
    }
        
    
    func icon(for item: SidebarItem) -> String {
        switch item {
            case .home: return "house"
            case .tag: return "tag"
            case .about: return "info.circle"
            case .quiz: return "graduationcap"
        }
    }
}

#Preview {
    ContentView()
        .tint(.orange)
}
