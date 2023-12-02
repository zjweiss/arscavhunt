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
            .padding(.horizontal, 6)
            .padding(.vertical, 6)
            .background(Color(
                red: 191 / 255.0,
                green: 219 / 255.0,
                blue: 254 / 255.0
            ))
            .foregroundColor(Color(red: 23/255, green: 37/255, blue: 84/255))
            .cornerRadius(10)
    }
}
