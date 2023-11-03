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
    var isChecked: Bool
    
    static func preview() -> ActiveQuestInfo {
        ActiveQuestInfo(
             id: "1",
             name: "DOW",
             description: "“Home to mechanical engineering and chemical engineering departments.”",
             image: "dow_building",
             isChecked: false
        )
    }
}

struct ActiveQuestInfoContent: View {
    @State private var all_quests: [ActiveQuestInfo] = [
        ActiveQuestInfo(
            id: "1",
            name: "DOW",
            description: "“Home to mechanical engineering and chemical engineering departments.”",
            image: "dow_building",
            isChecked: false
        ),
        ActiveQuestInfo(
            id: "2",
            name: "Law Quad",
            description: "“Home to mechanical engineering and chemical engineering departments.”",
            image: "dow_building",
            isChecked: false
        ),
        ActiveQuestInfo(
            id: "3",
            name: "Duderstadt Center",
            description: "“Home to mechanical engineering and chemical engineering departments.”",
            image: "dow_building",
            isChecked: false
        )    
    ]
    
    @State private var checkedQuestCount = 0 // Variable to count checked quests
    // Compute the number of unchecked quests
    var uncheckedQuestCount: Int {
        all_quests.count - checkedQuestCount
    }

    var body: some View {
        Spacer()
        HStack{
            VStack{
                // Completed count changes according to the quest completed
                Text(String(checkedQuestCount))
                    .font(.custom("Times New Roman", size: 30))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("Completed")
                    .font(.custom("Times New Roman", size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray) // Set the text color to gray
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            Rectangle()
                .frame(width: 1, height: 50) // Set the width and height of the vertical line
                .foregroundColor(Color.gray) // Set the color of the line
            VStack{
                Text(String(uncheckedQuestCount)) // Display the number of unchecked quests
                    .font(.custom("Times New Roman", size: 30))
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                Text("To Go")
                    .font(.custom("Times New Roman", size: 12))
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray) // Set the text color to gray
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        Spacer()
        ForEach($all_quests, id: \.id) {
            $quest in
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
                        // TODO: like center alignment better, open for discussion 
                        Text(name)
                            .font(.custom("Times New Roman", size: 30))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white) // Set the font color to white
                            .padding()
                    }
                    Checkbox(isChecked: $quest.isChecked, checkedQuestCount: $checkedQuestCount)
                        .padding(10) // Adjust the padding of the checkbox
                        .position(x: UIScreen.main.bounds.width - 75, y: 40) // Position the checkbox at the top right corner
                    if let description = quest.description {
                        // TODO: make text easier to see (tried lining white text with black outline)
                        Text(description)
                            .font(.custom("Times New Roman", size: 12))
                            .fontWeight(.bold)
                            .foregroundColor(Color.white) // Fill color
                            .padding(5) // Adjust the padding for the outline effect
                            .position(x: 175, y: 240) // Position the text at the top-left corner
                            .background(
                                Text(description)
                                    .font(.custom("Times New Roman", size: 12))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.black) // Outline color
                                    .position(x: 175, y: 240) // Position the text at the top-left corner
                            )
                    }
                    Spacer()
                }
            }
        }
    }
}

struct Checkbox: View {
    @Binding var isChecked: Bool
    @Binding var checkedQuestCount: Int

    var body: some View {
        Button(action: {
            isChecked.toggle()
            checkedQuestCount = isChecked ? checkedQuestCount + 1 : checkedQuestCount - 1
        }) {
            Image(systemName: isChecked ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(isChecked ? Color.green : Color.gray)
        }
    }
}
