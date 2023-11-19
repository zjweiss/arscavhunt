//
 //  LeaderboardRow.swift
 //  ScavengARQuest
 //
 //  Created by Janice Liu on 11/1/23.
 //
 import SwiftUI

 struct LeaderboardRow: View {
     var currentUserId: Int
     
     var user: User
     
     let backgroundColor = Color(red: 23/255, green: 37/255, blue: 84/255)
     
     var body: some View {
         HStack(alignment: .center) {
             Text(String(user.ranking))
                 .font(.system(size: 20).monospacedDigit())
                 .foregroundStyle(Color.gray)
                 .padding(.trailing, 8)
             
             Text(user.firstName + " " + user.lastName)
                 .font(.system(size: 20))
             
             Spacer()
             
             Text(user.totalPoints)
                 .font(.system(size: 25))
                 .fontWeight(.semibold)
         }
         .padding(8)
         .background(currentUserId == user.userId ? backgroundColor.opacity(0.15) : nil)
         .cornerRadius(10.0)
     }
}
