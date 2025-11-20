//
//  EditWordView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import Observation

struct EditWordView: View {
    @EnvironmentObject var store: WordStore
    @ObservedObject var word: Word
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack {
            Toggle(isOn: $isEditing) {
                Text("Editing")
            }
            Spacer()
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Label("Delete Word", systemImage: "trash")
                    .foregroundColor(.red) // Force red color on macOS sidebar
            }
            .alert("Delete this word?", isPresented: $showDeleteConfirmation) {
                // The destructive role here makes the button red inside the Alert popup
                Button("Delete", role: .destructive) {
                    store.delete(word)
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
        }
        .padding(EdgeInsets.init(top: 5, leading: 15, bottom: 0, trailing: 15))
        Form(content: {
            if isEditing {
                Section {
                    // 1. Choose Type
                    Picker("Word Type", selection: $word.grammaticalType) {
                        ForEach(GrammaticalType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    
                    // 2. Common Field
                    TextField(text: $word.german) {
                        Text("German word")
                    }
                    .textFieldStyle(.squareBorder)
                    .padding(.trailing, 30)
                    // 2. Overlay the button on the right side
                    .overlay(alignment: .trailing) {
                        Button {
                            searchDictionary(for: word.german)
                        } label: {
                            Image(systemName: "text.magnifyingglass")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless) // Important for making it fit inside
                        .padding(.trailing, 8)    // Slight offset from the edge
                        .help("Search in Apple Dictionary")
                        .disabled(word.german.isEmpty)   // Disable if field is empty
                    }
                    TextField(text: $word.english) {
                        Text("Translation")
                    }
                    .textFieldStyle(.squareBorder)
                    
                } header: { Text("Word") }
                
                // 3. Dynamic Fields based on selection
                Section {
                    if word.grammaticalType == .noun, let noun = word as? Noun {
                        Picker("Gender", selection: Binding(get: {noun.gender}, set: {noun.gender = $0})) {
                            ForEach(Gender.allCases, id: \.self) { gender in
                                Text(gender.rawValue).tag(gender)
                            }
                        }
                        if (noun.gender != .plural) {
                            TextField(text: Binding<String>(
                                get: { noun.pluralForm ?? "" },
                                set: { noun.pluralForm = $0.isEmpty ? nil : $0 }
                            )) {
                                Text("Plural form")
                            }
                            .textFieldStyle(.squareBorder)
                        }
                        
                    } else if word.grammaticalType == .verb, let verb = word as? Verb {
                        Toggle("Is separable", isOn: Binding(get: {verb.isSeparable}, set: {verb.isSeparable = $0}))
                        Toggle("Is regular", isOn: Binding(get: {verb.isRegular}, set: {verb.isRegular = $0}))
                        if (!verb.isRegular) {
                            TextField(text: Binding<String>(
                                get: { verb.present ?? "" },
                                set: { verb.present = $0.isEmpty ? nil : $0 }
                            )) {
                                Text("Present form")
                            }
                            .textFieldStyle(.squareBorder)
                            
                            TextField(text: Binding<String>(
                                get: { verb.imperfect ?? "" },
                                set: { verb.imperfect = $0.isEmpty ? nil : $0 }
                            )) {
                                Text("Imperfect form")
                            }
                            .textFieldStyle(.squareBorder)
                            
                            TextField(text: Binding<String>(
                                get: { verb.pastParticiple ?? "" },
                                set: { verb.pastParticiple = $0.isEmpty ? nil : $0 }
                            )) {
                                Text("Past participle form")
                            }
                            .textFieldStyle(.squareBorder)
                            
                        }
                        Picker("Auxiliary verb", selection: Binding(get: {verb.auxiliary}, set: {verb.auxiliary = $0})) {
                            ForEach(["haben", "sein"], id: \.self) { aux in
                                Text(aux).tag(aux)
                            }
                        }
                        
                    } else if word.grammaticalType == .adjective, let adj = word as? Adjective {
                        Toggle("Is regular", isOn: Binding(get: {adj.isRegular}, set: {adj.isRegular = $0}))
                        if (!adj.isRegular) {
                            TextField(text: Binding<String>(
                                get: { adj.comparativeForm ?? "" },
                                set: { adj.comparativeForm = $0.isEmpty ? nil : $0 }
                            )) {
                                Text("Comparative form")
                            }
                            .textFieldStyle(.squareBorder)
                            
                        }
                        
                    } else if word.grammaticalType == .preposition, let prep = word as? Preposition {
                        Picker("Case", selection: Binding(get: {prep.nounCase}, set: {prep.nounCase = $0})) {
                            ForEach(["Nominative", "Accusative", "Dative", "Genitive"], id: \.self) { kase in
                                Text(kase).tag(kase)
                            }
                        }
                    }
                } header: { Text("Details") }
                
                // generic misc fields
                Section {
                    VStack {
                        Text("Example Sentences")
                        TextEditor(text: Binding<String>(
                            get: { word.exampleSentence ?? "" },
                            set: { word.exampleSentence = $0.isEmpty ? nil : $0 }
                        ))
                        .font(.system(size: 12))
                        .frame(height: 80)
                        .cornerRadius(8)
                    }
                    VStack {
                        Text("Notes")
                        TextEditor(text: Binding<String>(
                            get: { word.notes ?? "" },
                            set: { word.notes = $0.isEmpty ? nil : $0 }
                        ))
                        .font(.system(size: 12))
                        .frame(height: 130)
                        .cornerRadius(8)
                    }
                } header: { Text("Examples and Notes") }
            } else {
                Section {
                    LabeledContent("Word Type") { Text(word.grammaticalType.rawValue) }
                    LabeledContent("German word") {
                        Text(word.german)
                    }
                    .padding(.trailing, 30)
                    .overlay(alignment: .trailing) {
                        Button {
                            searchDictionary(for: word.german)
                        } label: {
                            Image(systemName: "text.magnifyingglass")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless) // Important for making it fit inside
                        .padding(.trailing, 8)    // Slight offset from the edge
                        .help("Search in Apple Dictionary")
                    }
                    
                    LabeledContent("Translation") { Text(word.english) }
                } header: { Text("Word") }
                
                Section {
                    if let noun = word as? Noun {
                        LabeledContent("Gender") { Text(noun.gender.rawValue) }
                        if noun.gender != .plural {
                            LabeledContent("Plural form") { Text(noun.pluralForm ?? "") }
                        }
                    }
                    
                    else if let verb = word as? Verb {
                        LabeledContent("Is separable") { Text(verb.isSeparable ? "Yes" : "No") }
                        LabeledContent("Is regular") { Text(verb.isRegular ? "Yes" : "No") }
                        if !verb.isRegular {
                            LabeledContent("Present form") { Text(verb.present ?? "") }
                            LabeledContent("Imperfect form") { Text(verb.imperfect ?? "") }
                            LabeledContent("Past participle") { Text(verb.pastParticiple ?? "") }
                        }
                        LabeledContent("Auxiliary Verb") { Text(verb.auxiliary) }
                    }
                    
                    else if let adj = word as? Adjective {
                        LabeledContent("Is regular") { Text(adj.isRegular ? "Yes" : "No") }
                        if !adj.isRegular {
                            LabeledContent("Comparative form") { Text(adj.comparativeForm ?? "") }
                        }
                    }
                    
                    else if let prep = word as? Preposition {
                        LabeledContent("Noun case") { Text(prep.nounCase) }
                    }
                } header: { Text("Details") }
                
                Section {
                    VStack {
                        Text("Example Sentences")
                        ScrollView {
                            Text(word.exampleSentence ?? "")
                                .font(.body)
                                .frame(maxWidth: .infinity, minHeight: 80, alignment: .leading) // Align text to top-left
                                .textSelection(.enabled) // ✅ Allows copying text
                        }
                        .padding(8) // Match TextEditor default padding
                        .background(Color(nsColor: .textBackgroundColor))
                        .frame(height: 80)
                        .cornerRadius(8)
                    }
                    VStack {
                        Text("Notes")
                        ScrollView {
                            Text(word.notes ?? "")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to top-left
                                .textSelection(.enabled) // ✅ Allows copying text
                        }
                        .padding(8) // Match TextEditor default padding
                        .background(Color(nsColor: .textBackgroundColor))
                        .frame(height: 130)
                        .cornerRadius(8)

                    }
                } header: { Text("Examples and Notes") }
            }
        })
    }
}

