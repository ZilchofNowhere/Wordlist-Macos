//
//  QuizView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//

import SwiftUI
import SwiftData
import AppKit

struct QuizView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private var startedQuiz: Bool = false
    @State private var words: [Word] = [] // index 0 is the asked one, the rest will constitute the options
    @State private var wasCorrect: Bool? = nil
    @State private var score = 0
    @State private var fromGermanToEnglish: Bool = true
    
    var body: some View {
        ZStack {
            if !startedQuiz {
                Button {
                    words = getRandomWords()
                    startedQuiz = true
                } label: {
                    Label("Start", systemImage: "play")
                }
                .buttonStyle(.glassProminent)
                .controlSize(.extraLarge)
            }
            else {
                // asked word
                VStack {
                    
                }
                
                // options
                VStack {
                    ForEach(words[1...], id: \.self) { word in
                        
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .status) {
                Button {
                    fromGermanToEnglish.toggle()
                } label: {
                    Image(nsImage: fromGermanToEnglish ? "🇩🇪 → 🇬🇧".emojiToImage()! : "🇬🇧 → 🇩🇪".emojiToImage()!)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                }
            }
        }
    }
    
    private func getRandomWords() -> [Word] {
        var randomWords: [Word] = []
        var indices = Set<Int>()
        do {
            let descriptor = FetchDescriptor<Word>()
            let count = try modelContext.fetchCount(descriptor)
            
            if count < 4 {
                randomWords = try modelContext.fetch(descriptor)
            }
            
            for _ in 0..<4 {
                indices.insert(Int.random(in: 0...count))
            }
            
            for i in indices {
                var desc = FetchDescriptor<Word>(sortBy: [SortDescriptor(\.german)])
                desc.fetchLimit = 1
                desc.fetchOffset = i
                
                if let word = try modelContext.fetch(desc).first {
                    randomWords.append(word)
                }
            }
        } catch {
            print(error)
        }
        
        return randomWords
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
