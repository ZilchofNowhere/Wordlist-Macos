//
//  TagsView.swift
//  Wordlist
//
//  Created by Arda Eren Kartal on 18.11.2025.
//


import SwiftUI

struct TagCategoryView: View {
    let category: SidebarItem.TagCategory

    var body: some View {
        Text(category.rawValue)
            .font(.largeTitle)
    }
}
