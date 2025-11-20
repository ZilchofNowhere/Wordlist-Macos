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
    
    var body: some View {
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
                DisclosureGroup(isExpanded: $isTagsOnSidebarExtended) {
                    ForEach(GrammaticalType.allCases, id: \.self) { category in
                        NavigationLink(value: SidebarItem.tag(category)) {
                            Label(category.rawValue + "s", systemImage: "tag")
                        }
                    }
                } label: {
                    Label("Tags", systemImage: "tag.square")
                }
            }
            
            Section {
                NavigationLink(value: SidebarItem.about) {
                    Label("About", systemImage: "info.circle")
                }
            }
        }
            .listStyle(.sidebar)
    }
}
