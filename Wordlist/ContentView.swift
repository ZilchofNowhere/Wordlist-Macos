//
//  ContentView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

enum SidebarItem: Hashable, Identifiable {
    case home
    case about
    case tag(TagCategory)
    case manageTags

    var id: String {
        switch self {
            case .home: return "home"
            case .about: return "about"
            case .tag(let cat): return cat.rawValue
            case .manageTags: return "manageTags"
        }
    }

    enum TagCategory: String, CaseIterable {
        case nouns = "Nouns"
        case verbs = "Verbs"
        case adjectives = "Adjectives"
        case adverbs = "Adverbs"
        case pronouns = "Pronouns"
    }
}

import SwiftUI

struct ContentView: View {
    @State private var selection: SidebarItem? = .home
    @State private var query = ""
    @State private var selectedSegment = 0

    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                // Main section
                Section {
                    NavigationLink(value: SidebarItem.home) {
                        Label("Home", systemImage: "house")
                    }
                }

                // TAGS SECTION
                Section("Tags") {
                    NavigationLink(value: SidebarItem.manageTags) {
                        Label("Manage tags", systemImage: "folder.badge.gearshape")
                    }
                    ForEach(SidebarItem.TagCategory.allCases, id: \.self) { category in
                        NavigationLink(value: SidebarItem.tag(category)) {
                            Label(category.rawValue, systemImage: "tag")
                        }
                    }
                }
                
                Section {
                    NavigationLink(value: SidebarItem.about) {
                        Label("About", systemImage: "info.circle")
                    }
                }
            }
                .listStyle(.sidebar)
        } detail: {
            switch selection {
            case .home:
                HomeView()
            case .tag(let category):
                TagCategoryView(category: category)
            case .about:
                AboutView()
            case .manageTags:
                ManageTagsView()
            case .none:
                Text("Select a page")
            }
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                HStack {
                    TextField("Words…", text: $query)
                        .textFieldStyle(.roundedBorder)
                        .frame(width: 220)

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
                    // either add a new word or a new tag
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
    
    func icon(for item: SidebarItem) -> String {
        switch item {
            case .home: return "house"
            case .tag: return "tag"
            case .about: return "info.circle"
            case .manageTags: return "folder.badge.gearshape"
        }
    }
}

#Preview {
    ContentView()
        .tint(.orange)
}
