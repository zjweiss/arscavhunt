//
 //  LeaderboardRow.swift
 //  ScavengARQuest
 //
 //  Created by Janice Liu on 11/1/23.
 //
 import SwiftUI

 struct LeaderboardRow: View {
     var index: Int
     var currentUserId: Int
     var user: User
     
    var body: some View {
        HStack(alignment: .center) {
            Text(String(index+1))
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
        .background(currentUserId == user.userId ? Color.yellow.opacity(0.1) : nil)
        .cornerRadius(10.0)
    }
}
