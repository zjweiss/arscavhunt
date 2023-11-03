//
//  ActiveQuestPage.swift
//  ScavengARQuest
//
//  Created by Janice Liu on 11/1/23.
//

import SwiftUI

struct ActiveQuestPage: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    HStack {
                        Button(action: {
                            // TODO: add back button action (goes back to quest detail page)
                        }) {
                            Image(systemName: "chevron.left")
                                .scaleEffect(0.6)
                                .font(Font.title.weight(.medium))
                        }
                        Spacer()
                        Image(systemName: "app.gift")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                        Image(systemName: "bell")
                            .imageScale(.large)
                            .foregroundStyle(.tint)
                    }
                    Spacer()
                    Text("Campus Study Spots")
                        .font(.custom("Times New Roman", size: 30))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VStack{
                        ActiveQuestInfoContent()
                            .frame(maxWidth: .infinity)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding()
            }
        }
    }
}

struct ActiveQuestPage_Preview: PreviewProvider {
    static var previews: some View {
        ActiveQuestPage()
    }
}
