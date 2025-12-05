//
//  QuizView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData
import AppKit
// Helpers will be added later

struct QuizView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var startedQuiz: Bool = false
    @State private var showNextQuestion: Bool = false
    @State private var showImages: Bool = true
    @State private var showStats: Bool = false
    @State private var words: [Word] = [] // index 0 is the asked one, the rest will constitute the options
    @State private var options: [Word] = []
    @State private var chosenWord: Word? = nil
    @State private var wasCorrect: Bool? = nil
    @State private var score = 0
    @State private var totalAnswered = 0
    @State private var fromGermanToEnglish: Bool = true
    
    var body: some View {
        ZStack {
            if !startedQuiz {
                VStack(spacing: 30) {
                    Text("Willkommen!")
                        .font(.largeTitle)
                    Toggle("Images are shown", isOn: $showImages)
                        .toggleStyle(.switch)
                        .controlSize(.small)
                    Button {
                        words = getRandomWords()
                        options = words.shuffled()
                        startedQuiz = true
                    } label: {
                        Label("Start", systemImage: "play")
                    }
                    .buttonStyle(.glassProminent)
                    .controlSize(.extraLarge)
                }
            }
            else {
                VStack {
                    // asked word
                    VStack {
                        if let _ = words.first {
                            ZStack {
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.clear)
                                    .shadow(radius: 8)
                                    .frame(width: 400, height: 120)

                                HStack(spacing: 30) {
                                    Text(askedWordText())
                                        .font(.title2)

                                    if let image = askedWordImage(), showImages {
                                        Image(nsImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .clipShape(RoundedRectangle(cornerRadius: 6))
                                    }
                                }
                            }
                        }
                    }
                    
                    // options
                    VStack {
                        ForEach(options, id: \.self) { word in
                            Text(optionText(for: word))
                                .frame(width: 400, height: 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(answerBackground(word))
                                        .shadow(radius: 4)
                                )
                                .animation(.default, value: chosenWord)
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    chosenWord = word
                                    showNextQuestion = true
                                }
                        }
                    }
                    .padding(.bottom, 10)
                    HStack(spacing: 15) {
                        Button {
                            startedQuiz = false
                            score = 0
                            totalAnswered = 0
                            chosenWord = nil
                            wasCorrect = nil
                            showNextQuestion = false
                        } label: {
                            Label("Restart", systemImage: "arrow.counterclockwise")
                        }
                        
                        Button {
                            chosenWord = nil
                            wasCorrect = nil
                            words = getRandomWords()
                            options = words.shuffled()
                            showNextQuestion = false
                        } label: {
                            Label("Next question", systemImage: "arrow.forward.circle")
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!showNextQuestion)
                    }
                }
            }
        }
        .onChange(of: chosenWord) { _, newValue in
            guard let choice = newValue, let asked = words.first else { return }
            if choice == asked {
                wasCorrect = true
                score += 1
            } else {
                wasCorrect = false
            }
            totalAnswered += 1
        }
        .sheet(isPresented: $showStats) {
            StatsView(showStats: $showStats, score: $score, totalAnswered: $totalAnswered)
        }
        .toolbar {
            ToolbarItem(placement: .status) {
                Button() {
                    fromGermanToEnglish.toggle()
                } label: {
                    Label {
                        Text("Switch languages")
                    } icon: {
                        Image(nsImage: fromGermanToEnglish ? "🇩🇪 → 🇬🇧".emojiToImage()! : "🇬🇧 → 🇩🇪".emojiToImage()!)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 25)
                    }
                }
            }
            
            ToolbarItem(placement: .secondaryAction) {
                Button {
                    showStats = true
                } label: {
                    Label("Stats", systemImage: "chart.xyaxis.line")
                }
            }
        }
    }
    
    private func answerBackground(_ word: Word) -> Color {
        if wasCorrect == nil {
            return .clear
        } else if wasCorrect == true && word == chosenWord {
            return .green
        } else if wasCorrect == false && word == chosenWord {
            return .red
        } else if wasCorrect == false && word == words[0] {
            return .green
        } else {
            return .clear
        }
    }
    
    private func getRandomWords() -> [Word] {
        let optionCount = 4
        do {
            let descriptor = FetchDescriptor<Word>(sortBy: [SortDescriptor(\.german)])
            let all = try modelContext.fetch(descriptor)
            if all.isEmpty { return [] }
            if all.count <= optionCount {
                return all.shuffled()
            }
            var selected: [Word] = []
            var used = Set<Int>()
            while selected.count < optionCount {
                let idx = Int.random(in: 0..<all.count)
                if used.insert(idx).inserted {
                    selected.append(all[idx])
                }
            }
            return selected
        } catch {
            print(error)
            return []
        }
    }
    
    private func askedWordText() -> String {
        guard let asked = words.first else { return "" }
        return fromGermanToEnglish ? asked.german : asked.english
    }

    private func askedWordImage() -> NSImage? {
        guard let data = words.first?.imageData, let image = NSImage(data: data) else { return nil }
        return image
    }

    private func optionText(for word: Word) -> String {
        return fromGermanToEnglish ? word.english : word.german
    }
}

extension String {
    func emojiToImage() -> NSImage? {
        let nsString = self as NSString
        let font = NSFont.systemFont(ofSize: 1024)
        let attributes: [NSAttributedString.Key: Any] = [.font: font, .foregroundColor: NSColor.textColor]
        let imageSize = nsString.size(withAttributes: attributes)

        let image = NSImage(size: imageSize)
        image.lockFocus()
        defer { image.unlockFocus() }

        NSColor.clear.set()
        NSBezierPath(rect: CGRect(origin: .zero, size: imageSize)).fill()

        nsString.draw(at: .zero, withAttributes: attributes)

        return image
    }
}
