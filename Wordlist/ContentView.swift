//
//  ContentView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers
import TabularData


enum SidebarItem: Hashable, Identifiable {
    case home
    case type(GrammaticalType)
    case category(VocabTag)
    case quiz

    var id: String {
        switch self {
            case .home: return "home"
            case .type(let cat): return cat.rawValue
            case .category(let cat): return cat.rawValue
            case .quiz: return "quiz"
        }
    }
}

enum InspectorMode: Equatable {
    case none
    case addWord
    case editWord(Word)
}

enum SortMode: Equatable {
    case alphabetical
    case olderFirst
    case newerFirst
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var words: [Word]

    @State private var selection: SidebarItem? = .home
    @State private var query = ""
    @State private var selectedSegment = 0
    @State private var selectedWordId: UUID?
    @State private var inspectorMode: InspectorMode = .none
    @State private var sidebarVisibility: NavigationSplitViewVisibility = .all
    @State private var wasSidebarOpen: Bool = false
    @State private var sortMode = SortMode.alphabetical

    var body: some View {
        GeometryReader { geometry in
            NavigationSplitView(columnVisibility: $sidebarVisibility) {
                SidebarView(selection: $selection)
                    .frame(minWidth: 180)
            } detail: {
                switch selection {
                    case .home:
                        HomeView(filterString: query, selectedWordId: $selectedWordId, sortMode: $sortMode)
                    case .type(let category):
                        TagCategoryView(category: category, filterString: query, selectedWordId: $selectedWordId, sortMode: $sortMode)
                    case .category(let category):
                        VocabCategoryView(category: category, filterString: query, selectedWordId: $selectedWordId, sortMode: $sortMode)
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
            .onReceive(NotificationCenter.default.publisher(for: .exportCSV)) { _ in
                DispatchQueue.main.async {
                    exportToCSV()
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .importCSV)) { _ in
                DispatchQueue.main.async {
                    importFromCSV()
                }
            }
            .onChange(of: selection) { _, newValue in
                if newValue == .quiz {
                    inspectorMode = .none
                }
            }
            .onChange(of: geometry.size.width, initial: true) { _, newSize in
                if newSize < 731 {
                    if sidebarVisibility == .all {
                        wasSidebarOpen = true
                    }
                    sidebarVisibility = .detailOnly
                } else {
                    if wasSidebarOpen {
                        sidebarVisibility = .all
                        wasSidebarOpen = false
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
                if selection != .quiz {
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
                    ToolbarItem(placement: .automatic) {
                        Menu {
                            Button {
                                sortMode = .alphabetical
                            } label: {
                                Label("Alphabetical order", systemImage: sortMode == .alphabetical ? "checkmark" : "")
                            }
                            
                            Button {
                                sortMode = .newerFirst
                            } label: {
                                Label("Newer first", systemImage: sortMode == .newerFirst ? "checkmark" : "")
                            }
                            
                            Button {
                                sortMode = .olderFirst
                            } label: {
                                Label("Older first", systemImage: sortMode == .olderFirst ? "checkmark" : "")
                            }
                        } label: {
                            Label("Sort By...", systemImage: "line.3.horizontal.decrease.circle")
                        }
                    }
                }
            }
        }
    }
    
    private func exportToCSV() {
        do {
            let descriptor = FetchDescriptor<Word>(sortBy: [SortDescriptor(\.german)])
            let allWords = try modelContext.fetch(descriptor)
            
            var resultStr = "timestamp,german,english,type,gender,pluralForm,isRegular,isSeparable,present,imperfect,pastParticiple,auxiliary,comparativeForm,nounCase,exampleSentence,notes,vocabTag\n"
            
            for word in allWords {
                resultStr.append(word.toCSV() + "\n")
            }
            
            saveExportToFile(resultStr)
        } catch {
            print("Failed to export to CSV: \(error)")
        }
    }
    
    private func saveExportToFile(_ str: String) {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [.commaSeparatedText]
        savePanel.nameFieldStringValue = "words.csv"
        savePanel.canCreateDirectories = true
        savePanel.isExtensionHidden = false
        savePanel.title = "Export to CSV"
        savePanel.message = "Choose a location to save your CSV file."
        
        let response = savePanel.runModal()
        if response == .OK {
            guard let destinationURL = savePanel.url else { return }
            try? str.write(to: destinationURL, atomically: true, encoding: .utf8)
        }
    }
    
    private func importFromCSV() {
        let openPanel = NSOpenPanel()
        openPanel.allowedContentTypes = [.commaSeparatedText]
        openPanel.isExtensionHidden = false
        openPanel.title = "Import from CSV"
        openPanel.message = "Choose a CSV file to import."
        
        let response = openPanel.runModal()
        if response == .OK {
            guard let sourceURL = openPanel.url else { return }
            print("Importing from: \(sourceURL.path)")
            
            CSVtoWord(from: sourceURL)
        }
    }
    
    private func CSVtoWord(from url: URL) {
        let loadOptions = CSVReadingOptions(hasHeaderRow: true, delimiter: ",")
        do {
            let dataFrame = try DataFrame(contentsOfCSVFile: url, options: loadOptions)
            
            for row in dataFrame.rows {
                print(row)
                let timestampStr = row["timestamp"] as? Double
                let german = row["german"] as? String
                let english = row["english"] as? String
                let typeStr = row["type"] as? String
                let genderStr = row["gender"] as? String
                let pluralForm = row["pluralForm"] as? String
                let isRegularStr = row["isRegular"] as? String
                let isSeparableStr = row["isSeparable"] as? String
                let present = row["present"] as? String
                let imperfect = row["imperfect"] as? String
                let pastParticiple = row["pastParticiple"] as? String
                let auxiliary = row["auxiliary"] as? String
                let comparativeForm = row["comparativeForm"] as? String
                let nounCase = row["nounCase"] as? String
                let exampleSentence = row["exampleSentence"] as? String
                let notes = row["notes"] as? String
                let tempTags = row["vocabTag"] as? String

                let timestamp = Date(timeIntervalSince1970: timestampStr!)
                let gender = genderStr == nil || genderStr!.isEmpty ? nil : Gender(rawValue: genderStr!)
                let isRegular = isRegularStr == "true"
                let isSeparable = isSeparableStr == "true"
                let vocabTag: [VocabTag] = tempTags == nil || tempTags!.isEmpty ? [] : tempTags!.split(separator: ",", omittingEmptySubsequences: true).map { VocabTag.init(rawValue: String($0))! }
                
                let type = GrammaticalType(rawValue: typeStr!)!
                
                let newWord = Word(german: german!, english: english!, type: type, vocabTag: vocabTag, notes: notes, exampleSentence: exampleSentence, gender: gender, pluralForm: pluralForm, isRegular: isRegular, isSeparable: isSeparable, present: present, imperfect: imperfect, pastParticiple: pastParticiple, auxiliary: auxiliary, comparativeForm: comparativeForm, nounCase: nounCase, timestamp: timestamp)
                
                modelContext.insert(newWord)
            }
        }
        catch {
            print(error)
        }
    }
}

extension Notification.Name {
    static let exportCSV = Notification.Name("exportCSV")
    static let importCSV = Notification.Name("importCSV")
}
