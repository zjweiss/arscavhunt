//
//  ActiveQuestListRow.swift
//  ScavengARQuest
//
//  Created by Janice Liu on 11/2/23.
//

import SwiftUI

struct ActiveQuestLocationCard: View {
    @State var data: Location
    @State var isPresented: Bool = false
    @Binding var completedQuests: Int
    
    @ViewBuilder
    func Checkbox() -> some View {
        let isComplete: Bool = data.status == "complete"
        
        Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(isComplete ? Color.green : Color.white)
    }
    
    @ViewBuilder
    func Card() -> some View {
        ZStack {
            if let imageUrl = URL(string: data.thumbnail) {
                AsyncImage(url: imageUrl){
                    $0.resizable()
                        .scaledToFit()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.tint)
                        .cornerRadius(10.0)
                } placeholder: {
                    ProgressView()
                }
                
            }


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
    
    
    var body: some View {
        Button {
            isPresented.toggle()
        } label: {
            Card()
        }
        .sheet(isPresented: $isPresented, content: {
            LocationDetails(locationDetailStore: $data, completedQuests: $completedQuests)
        })
    }
}
