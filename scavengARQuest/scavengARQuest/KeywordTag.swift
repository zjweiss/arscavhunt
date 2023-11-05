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
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                ForEach(keywords.split(separator: ","), id: \.self) { keyword in
                    KeywordPill(keyword: keyword.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
    }
}

struct KeywordPill: View {
    let keyword: String

    var body: some View {
        Text(keyword)
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}
