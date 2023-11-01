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
                            // TODO: add back button action
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
                    Spacer()
                    HStack{
                        VStack{
                            // TODO: Change complete/togo to pull from data structure
                            Text("5")
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
                            Text("1")
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
