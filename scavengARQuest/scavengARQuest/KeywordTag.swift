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
            .background(Color(red: 191 / 255, green: 219 / 255, blue: 254 / 255)) // Hex: #BFDBFE
            .foregroundColor(Color(red: 0.1176, green: 0.2275, blue: 0.5412))
            .cornerRadius(10)
    }
}
