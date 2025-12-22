//
//  ManageTagsView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 12.12.2025.
//

import SwiftUI
import SwiftData

struct ManageTagsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var tags: [VocabularyTag]
    
    @State private var showAddTagDialog: Bool = false
    @State private var name: String = ""
    @State private var icon: String = ""
    @State private var iconIsEmoji = false
    
    var body: some View {
        List {
            ForEach(tags) { tag in
                if tag.iconIsEmoji {
                    Label {
                        Text(tag.name)
                    } icon: {
                        Image(nsImage: tag.icon.emojiToImage()!)
                    }
                } else {
                    Label(tag.name, systemImage: tag.icon)
                }
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    showAddTagDialog.toggle()
                } label: {
                    Label("Add Tag", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showAddTagDialog) {
            VStack(spacing: 15) {
                Text("Add Tag")
                    .font(.title2)
                
                Form {
                    Section {
                        TextField(text: $name) {
                            Text("Name")
                        }
                        
                        TextField(text: $icon) {
                            Text("Icon")
                        }
                        
                        Toggle(isOn: $iconIsEmoji) {
                            Text("Icon is an emoji?")
                        }
                    }
                }
                
                Button {
                    modelContext.insert(VocabularyTag(name: name, icon: icon, iconIsEmoji: iconIsEmoji))
                    name = ""
                    icon = ""
                    iconIsEmoji = false
                } label: {
                    Text("Save")
                }
            }
            .frame(width: 300, height: 200)
            .padding(.vertical, 20)
            .padding(.horizontal, 20)
        }
    }
}
