//
//  ActiveQuestListRow.swift
//  ScavengARQuest
//
//  Created by Janice Liu on 11/2/23.
//

import SwiftUI

struct ActiveQuestLocationCard: View {
    let data: Location
    
    @ViewBuilder
    func Checkbox() -> some View {
        let isComplete: Bool = data.status == "complete"
        
        Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(isComplete ? Color.green : Color.white)
    }
    
    var body: some View {
        ZStack {
            Image("dow_building")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.tint)
                .cornerRadius(10.0)

            RoundedRectangle(cornerRadius: 10.0)
                .foregroundColor(Color.black.opacity(0.30))
            
            HStack {
                Spacer()
                VStack {
                    Checkbox()
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                    Spacer()
                }
            }

            Text(data.name)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
        }
    }
}
