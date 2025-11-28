//
//  AddWordView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData

struct AddWordView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    
    @State private var german: String = ""
    @State private var english: String = ""
    @State private var wordType: GrammaticalType = .noun
    @State private var notes: String = ""
    @State private var exampleSentence: String = ""
    @State private var vocabTag: [VocabTag] = []
    
    // noun fields
    @State private var gender: Gender = .masculine
    @State private var pluralForm: String = ""
    
    // verb fields
    @State private var isRegular: Bool = true
    @State private var isSeparable: Bool = false
    @State private var present: String = ""
    @State private var imperfect: String = ""
    @State private var pastParticiple: String = ""
    @State private var auxiliary: String = "haben"
    
    // adjective fields (+ isRegular)
    @State private var comparative: String = ""
    
    // preposition fields
    @State private var nounCase: String = "Accusative"
    
    var body: some View {
        Form {
            Section("Word") {
                // 1. Choose Type
                Picker("Word Type", selection: $wordType) {
                    ForEach(GrammaticalType.allCases) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                // 2. Common Field
                TextField(text: $german) {
                    Text("German word")
                }
                    .textFieldStyle(.squareBorder)
                    .padding(.trailing, 30)
                // 2. Overlay the button on the right side
                    .overlay(alignment: .trailing) {
                        Button {
                            searchDictionary(for: german)
                        } label: {
                            Image(systemName: "text.magnifyingglass")
                                .foregroundColor(.secondary)
                        }
                        .buttonStyle(.borderless) // Important for making it fit inside
                        .padding(.trailing, 8)    // Slight offset from the edge
                        .help("Search in Apple Dictionary")
                        .disabled(german.isEmpty)   // Disable if field is empty
                    }
                TextField(text: $english) {
                    Text("English translation")
                }
                    .textFieldStyle(.squareBorder)

            }
            
            // 3. Dynamic Fields based on selection
            if [.noun, .verb, .adjective, .preposition].contains(where: { $0 == wordType }) {
                Section("Details") {
                    if wordType == .noun {
                        Picker("Gender", selection: $gender) {
                            ForEach(Gender.allCases) { gender in
                                Text(gender.rawValue).tag(gender)
                            }
                        }
                        if (gender != .plural) {
                            TextField(text: $pluralForm) {
                                Text("Plural form")
                            }
                                .textFieldStyle(.squareBorder)
                        }
                        
                    } else if wordType == .verb {
                        Toggle("Is separable", isOn: $isSeparable).toggleStyle(.checkbox)
                        Toggle("Is regular", isOn: $isRegular).toggleStyle(.checkbox)
                        if (!isRegular) {
                            TextField(text: $present) {
                                Text("Present form")
                            }
                                .textFieldStyle(.squareBorder)

                            TextField(text: $imperfect) {
                                Text("Imperfect form")
                            }
                                .textFieldStyle(.squareBorder)

                            TextField(text: $pastParticiple) {
                                Text("Past participle form")
                            }
                                .textFieldStyle(.squareBorder)

                        }
                        Picker("Auxiliary verb", selection: $auxiliary) {
                            ForEach(["haben", "sein"], id: \.self) { aux in
                                Text(aux).tag(aux)
                            }
                        }
                        
                    } else if wordType == .adjective {
                        Toggle("Is regular", isOn: $isRegular).toggleStyle(.checkbox)
                        if (!isRegular) {
                            TextField(text: $comparative) {
                                Text("Comparative form")
                            }
                                .textFieldStyle(.squareBorder)

                        }
                        
                    } else if wordType == .preposition {
                        Picker("Case", selection: $nounCase) {
                            ForEach(["Nominative", "Accusative", "Dative", "Genitive"], id: \.self) { kase in
                                Text(kase).tag(kase)
                            }
                        }
                    }
                }
            }
            
            // generic misc fields
            Section("Other Info") {
                VStack {
                    Text("Vocabulary Categories")
                    VocabTagChips(selection: $vocabTag)
                }
                VStack {
                    Text("Example Sentences")
                    TextEditor(text: $exampleSentence)
                        .font(.system(size: 12))
                        .frame(height: 80)
                        .cornerRadius(8)
                }
                VStack {
                    Text("Notes")
                    TextEditor(text: $notes)
                        .font(.system(size: 12))
                        .frame(height: 130)
                        .cornerRadius(8)
                }
            }
            // 4. Action Buttons
            Section {
                Button("Add Word") {
                    if (wordType == .noun) {
                        modelContext.insert(Word(german: german.capitalized, english: english, type: .noun, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence, gender: gender, pluralForm: pluralForm.capitalized))
                    } else if (wordType == .verb) {
                        modelContext.insert(Word(german: german, english: english, type: .verb, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence, isRegular: isRegular, isSeparable: isSeparable, present: present, imperfect: imperfect, pastParticiple: pastParticiple, auxiliary: auxiliary))
                    } else if (wordType == .adjective) {
                        modelContext.insert(Word(german: german, english: english, type: .adjective, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence, isRegular: isRegular, comparativeForm: comparative))
                    } else if (wordType == .preposition) {
                        modelContext.insert(Word(german: german, english: english, type: .preposition, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence, nounCase: nounCase))
                    } else {
                        modelContext.insert(Word(german: german, english: english, type: wordType, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence))
                    }
                    
                    german = ""
                    english = ""
                    wordType = .noun
                    notes = ""
                    exampleSentence = ""
                    vocabTag = []
                    gender = .masculine
                    pluralForm = ""
                    isRegular = true
                    isSeparable = false
                    present = ""
                    imperfect = ""
                    pastParticiple = ""
                    auxiliary = "haben"
                    comparative = ""
                    nounCase = "Accusative"
               }
                .disabled(german.isEmpty || english.isEmpty) // Prevent empty words
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity)
            }
        }
        // This makes the top of the inspector look standard
        .navigationTitle("Add Word")
        //.navigationBarTitleDisplayMode(.inline) // says it's unavailable on macOS
    }
}

func searchDictionary(for word: String) {
    // 1. Clean the text (remove extra spaces, encode for URL)
    let cleanedWord = word.trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard let encodedWord = cleanedWord.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
          let url = URL(string: "dict://\(encodedWord)") else {
        return
    }
    
    // 2. Open the native macOS Dictionary app
    NSWorkspace.shared.open(url)
}
