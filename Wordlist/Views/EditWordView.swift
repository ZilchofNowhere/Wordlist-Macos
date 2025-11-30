//
//  EditWordView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData

struct EditWordView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var word: Word
    @State private var isEditing = false
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        HStack {
            Toggle(isOn: $isEditing) {
                Text("Editing")
            }.toggleStyle(.switch)
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
                    modelContext.delete(word)
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
                    Picker("Word Type", selection: $word.type) {
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
                if [.noun, .verb, .adjective, .preposition].contains(where: { $0 == word.type }) {
                    Section {
                        switch word.type {
                            case .noun:
                                Picker("Gender", selection: Binding(get: {word.gender}, set: {word.gender = $0})) {
                                    ForEach(Gender.allCases, id: \.self) { gender in
                                        Text(gender.rawValue).tag(gender)
                                    }
                                }
                                if (word.gender != .plural) {
                                    TextField(text: Binding<String>(
                                        get: { word.pluralForm ?? "" },
                                        set: { word.pluralForm = $0.isEmpty ? nil : $0.capitalized }
                                    )) {
                                        Text("Plural form")
                                    }
                                    .textFieldStyle(.squareBorder)
                                }
                            case .verb:
                                Toggle("Is separable", isOn: Binding(get: {word.isSeparable}, set: {word.isSeparable = $0})).toggleStyle(.checkbox)
                                Toggle("Is regular", isOn: Binding(get: {word.isRegular}, set: {word.isRegular = $0})).toggleStyle(.checkbox)
                                if (!word.isRegular) {
                                    TextField(text: Binding<String>(
                                        get: { word.present ?? "" },
                                        set: { word.present = $0.isEmpty ? nil : $0 }
                                    )) {
                                        Text("Present form")
                                    }
                                    .textFieldStyle(.squareBorder)
    
                                    TextField(text: Binding<String>(
                                        get: { word.imperfect ?? "" },
                                        set: { word.imperfect = $0.isEmpty ? nil : $0 }
                                    )) {
                                        Text("Imperfect form")
                                    }
                                    .textFieldStyle(.squareBorder)
    
                                    TextField(text: Binding<String>(
                                        get: { word.pastParticiple ?? "" },
                                        set: { word.pastParticiple = $0.isEmpty ? nil : $0 }
                                    )) {
                                        Text("Past participle form")
                                    }
                                    .textFieldStyle(.squareBorder)
    
                                }
                                Picker("Auxiliary verb", selection: Binding(get: {word.auxiliary}, set: {word.auxiliary = $0})) {
                                    ForEach(["haben", "sein"], id: \.self) { aux in
                                        Text(aux).tag(aux)
                                    }
                                }
                            case .adjective:
                                Toggle("Is regular", isOn: Binding(get: {word.isRegular}, set: {word.isRegular = $0})).toggleStyle(.checkbox)
                                if (!word.isRegular) {
                                    TextField(text: Binding<String>(
                                        get: { word.comparativeForm ?? "" },
                                        set: { word.comparativeForm = $0.isEmpty ? nil : $0 }
                                    )) {
                                        Text("Comparative form")
                                    }
                                    .textFieldStyle(.squareBorder)
                                }
    
                            case .preposition:
                                Picker("Case", selection: Binding(get: {word.nounCase}, set: {word.nounCase = $0})) {
                                    ForEach(["Nominative", "Accusative", "Dative", "Genitive"], id: \.self) { kase in
                                        Text(kase).tag(kase)
                                    }
                                }
                            default:
                                EmptyView()
                        }
                    } header: { Text("Details") }
                }
                
                // generic misc fields
                Section {
                    VStack {
                        Text("Vocabulary Categories")
                        VocabTagChips(selection: $word.vocabTag)
                    }
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
                } header: { Text("Other Info") }
            }
            // view only mode
            else {
                Section {
                    LabeledContent("Word Type") { Text(word.type.rawValue) }
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
                
                if [.noun, .verb, .adjective, .preposition].contains(where: { $0 == word.type }) {
                    Section {
                        if word.type == .noun {
                            LabeledContent("Gender") { Text(word.gender != nil ? word.gender!.rawValue : "") }
                            if word.gender != .plural {
                                LabeledContent("Plural form") { Text(word.pluralForm ?? "") }
                            }
                        }
                        
                        else if word.type == .verb {
                            LabeledContent("Is separable") { Text(word.isSeparable ? "Yes" : "No") }
                            LabeledContent("Is regular") { Text(word.isRegular ? "Yes" : "No") }
                            if !word.isRegular {
                                LabeledContent("Present form") { Text(word.present ?? "") }
                                LabeledContent("Imperfect form") { Text(word.imperfect ?? "") }
                                LabeledContent("Past participle") { Text(word.pastParticiple ?? "") }
                            }
                            LabeledContent("Auxiliary Verb") { Text(word.auxiliary ?? "haben") }
                        }
                        
                        else if word.type == .adjective {
                            LabeledContent("Is regular") { Text(word.isRegular ? "Yes" : "No") }
                            if !word.isRegular {
                                LabeledContent("Comparative form") { Text(word.comparativeForm ?? "") }
                            }
                        }
                        
                        else if word.type == .preposition {
                            LabeledContent("Noun case") { Text(word.nounCase ?? "") }
                        }
                    } header: { Text("Details") }
                }
                
                Section {
                    if word.vocabTag != [] {
                        VStack {
                            Text("Vocabulary Categories")
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(word.vocabTag, id: \.self) { tag in
                                        Button {
                                            
                                        } label: {
                                            Text(tag.rawValue)
                                        }
                                        .buttonStyle(.bordered)
                                        .buttonBorderShape(.capsule)
                                        .controlSize(.small)
                                    }
                                }
                            }
                        }
                    }
                    VStack {
                        Text("Example Sentences")
                        ScrollView {
                            Text(word.exampleSentence ?? "")
                                .font(.body)
                                .frame(maxWidth: .infinity, alignment: .leading) // Align text to top-left
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
                } header: { Text("Other Info") }
            }
        })
        .navigationTitle("Editing \"\(word.german)\"")
    }
}
