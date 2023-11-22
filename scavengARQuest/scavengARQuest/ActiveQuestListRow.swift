//
//  ActiveQuestListRow.swift
//  ScavengARQuest
//
//  Created by Janice Liu on 11/2/23.
//

import SwiftUI

struct ActiveQuestLocationCard: View {
    @State var locationID: Int
    @State var isPresented: Bool = false
    private let store = ScavengarStore.shared

    @ViewBuilder
    func Checkbox() -> some View {
        let isComplete: Bool = store.locationDict[locationID]?.status == "complete"
        
        Image(systemName: isComplete ? "checkmark.circle.fill" : "circle")
            .resizable()
            .frame(width: 25, height: 25)
            .foregroundColor(isComplete ? Color.green : Color.white)
    }
    
    @ViewBuilder
    func Card() -> some View {
        let data: Location = store.locationDict[locationID] ?? Location(quest_id: -1, location_id: -1, name: "", latitude: "", longitude: "", description: "", thumbnail: "", ar_enabled: false, distance_threshold: "", status: "", points: "", tags: "")
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
            LocationDetails(locationID: locationID)
        })
    }
}
