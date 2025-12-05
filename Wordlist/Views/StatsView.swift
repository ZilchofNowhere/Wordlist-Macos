//
//  StatsView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 5.12.2025.
//

import SwiftUI

struct StatsView: View {
    @Binding var showStats: Bool
    @Binding var score: Int
    @Binding var totalAnswered: Int
    @State private var accuracy = 0.0
    
    var body: some View {
        VStack {
            Text("Stats")
                .font(.title2)
            Form {
                Section {
                    LabeledContent("Score") {
                        Text("\(score)")
                    }
                    
                    LabeledContent("Total words") {
                        Text("\(totalAnswered)")
                    }
                    
                    LabeledContent("Accuracy") {
                        Text(verbatim: String(totalAnswered != 0 ? Double(score * 10000 / totalAnswered) / 100.0 : 0.0) + "%")
                    }
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 30)
            .padding(.horizontal, 30)
            
            Button {
                showStats = false
            } label: {
                Text("Close")
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(30)
    }
}
