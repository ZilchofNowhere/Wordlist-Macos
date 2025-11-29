//
//  ContentView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData

enum SidebarItem: Hashable, Identifiable {
    case home
    case tag(GrammaticalType)
    case quiz

    var id: String {
        switch self {
            case .home: return "home"
            case .tag(let cat): return cat.rawValue
            case .quiz: return "quiz"
        }
    }
}

enum InspectorMode: Equatable {
    case none
    case addWord
    case editWord(Word)
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var words: [Word]

    @State private var selection: SidebarItem? = .home
    @State private var query = ""
    @State private var selectedSegment = 0
    @State private var selectedWordId: UUID?
    @State private var inspectorMode: InspectorMode = .none

    var body: some View {
        NavigationSplitView {
            SidebarView(selection: $selection)
                .frame(minWidth: 180)
        } detail: {
            switch selection {
                case .home:
                    HomeView(filterString: query, selectedWordId: $selectedWordId)
                case .tag(let category):
                    TagCategoryView(category: category, filterString: query, selectedWordId: $selectedWordId)
                case .quiz:
                    QuizView()
                case .none:
                    Text("Select a page")
            }
        }
        .searchable(text: $query, prompt: "Search words...")
        .inspector(isPresented: Binding(
            get: { inspectorMode != .none },
            set: { if !$0 { inspectorMode = .none }}
        )) {
            Group {
                switch inspectorMode {
                    case .none:
                        EmptyView()
                    case .addWord:
                        AddWordView()
                    case .editWord(let word):
                        EditWordView(word: word)
                }
            }
        }
        .onChange(of: selectedWordId) { oldValue, newValue in
            guard let newId = newValue else {
                if case .editWord = inspectorMode {
                    inspectorMode = .none
                }
                return
            }
            
            if let editedWord = words.first(where: { $0.id == newId }) {
                inspectorMode = .editWord(editedWord)
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    if (inspectorMode != .addWord) {
                        inspectorMode = .addWord
                    } else {
                        inspectorMode = .none
                    }
                } label: {
                    Image(systemName: "plus")
                }
                .help("Add a new word")
            }
            ToolbarItem(placement: .automatic) {
                Button {
                    if selectedWordId == nil {
                        if inspectorMode == .none {
                            inspectorMode = .addWord
                        } else {
                            inspectorMode = .none
                        }
                    } else {
                        if inspectorMode != .none && inspectorMode != .addWord {
                            inspectorMode = .none
                        } else {
                            let editedWord = words.first(where: { $0.id == $selectedWordId.wrappedValue! })
                            if editedWord == nil {
                                inspectorMode = .addWord
                                selectedWordId = nil
                            } else {
                                inspectorMode = .editWord(editedWord!)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "sidebar.right")
                }
                .help("Toggle the sidebar")
            }
        }
        
    }
        
    
    func icon(for item: SidebarItem) -> String {
        switch item {
            case .home: return "house"
            case .tag: return "tag"
            case .quiz: return "graduationcap"
        }
    }
}

#Preview {
    ContentView()
        .tint(.orange)
}
