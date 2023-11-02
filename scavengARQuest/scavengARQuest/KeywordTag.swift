//
//  KeywordTag.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/1/23.
//

import SwiftUI

struct KeywordTag: View {
    let keywords: String

    var body: some View {
        HStack(spacing: 8) {
            ForEach(keywords.split(separator: ","), id: \.self) { keyword in
                KeywordPill(keyword: keyword.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
}

struct KeywordPill: View {
    let keyword: String

    var body: some View {
        Text(keyword)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
