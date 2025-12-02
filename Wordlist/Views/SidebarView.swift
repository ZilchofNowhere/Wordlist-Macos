//
//  SidebarView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem?
    @State private var isTagsOnSidebarExtended: Bool = true
    @State private var isCategoriesOnSidebarExtended: Bool = true
    
    var body: some View {
        List(selection: $selection) {
            // Main section
            Section {
                NavigationLink(value: SidebarItem.home) {
                    Label("All Words", systemImage: "square.grid.2x2")
                }
                NavigationLink(value: SidebarItem.quiz) {
                    Label("Quiz", systemImage: "graduationcap")
                }
            }

            // TAGS SECTION
            Section {
                DisclosureGroup(isExpanded: $isTagsOnSidebarExtended) {
                    ForEach(GrammaticalType.allCases, id: \.self) { category in
                        NavigationLink(value: SidebarItem.type(category)) {
                            Label(category.rawValue + "s", systemImage: "tag")
                        }
                    }
                } label: {
                    Text("Word Types")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(5)
                }
            }
            
            Section {
                DisclosureGroup(isExpanded: $isCategoriesOnSidebarExtended) {
                    ForEach(VocabTag.allCases, id: \.self) { category in
                        NavigationLink(value: SidebarItem.category(category)) {
                            Label(category.rawValue, systemImage: icon(for: category))
                        }
                    }
                } label : {
                    Text("Categories")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                        .padding(5)
                }
            }
        }
            .listStyle(.sidebar)
    }
    
    private func icon(for item: VocabTag) -> String {
        switch item {
            case .animal: return "pawprint"
            case .city: return "building.2"
            case .food: return "fork.knife"
            case .family: return "figure.2.and.child.holdinghands"
            case .health: return "stethoscope"
            case .house: return "house"
            case .job: return "briefcase"
            case .plant: return "leaf"
            case .sport: return "soccerball.inverse"
            case .technology: return "bolt"
            case .school: return "book"
            case .science: return "flask"
            case .emotion: return "face.smiling"
            case .travel: return "airplane.up.right"
            case .art: return "paintpalette"
        }
    }
}
