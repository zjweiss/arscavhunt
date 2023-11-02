//
//  ActiveQuestListRow.swift
//  ScavengARQuest
//
//  Created by Janice Liu on 11/2/23.
//

import SwiftUI

struct ActiveQuestInfo: Codable, Hashable, Identifiable {

    let id: String?
    let name: String?
    let description: String?
    let image: String
    
    static func preview() -> ActiveQuestInfo {
        ActiveQuestInfo(
             id: "1",
             name: "DOW",
             description: "“Home to mechanical engineering and chemical engineering departments.”",
             image: "dow_building"
        )
    }
}

struct ActiveQuestInfoContent: View {
    let all_quests: [ActiveQuestInfo]
    
    var body: some View {
        ForEach(all_quests, id: \.id) {
            quest in
            VStack {
                ZStack{
                    Image(quest.image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity) // Make the image fill the width
                        .foregroundStyle(.tint)
                        .cornerRadius(5.0)
                        .padding(16) // Add padding on the sides
                        .blur(radius: 1) // Apply a blur effect
                    if let name = quest.name {
                        Text(name)
                            .font(.custom("Times New Roman", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white) // Set the font color to white
                            .position(x: 50, y: 30) // Position the text at the top-left corner
                            .padding()
                    }
                    // TODO: add check circle
                    if let description = quest.description {
                        Text(description)
                            .font(.custom("Times New Roman", size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white) // Set the font color to white
                            .position(x: 165, y: 225) // Position the text at the top-left corner
                            .padding()
                    }
                    Spacer()
                }
            }
        }
    }
}
