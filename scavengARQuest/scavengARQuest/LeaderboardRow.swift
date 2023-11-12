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
        HStack {
            Text(String(index+1))
                .font(.system(size: 20).monospacedDigit())
                .padding(.trailing, 8)
            
            Text(user.firstName + " " + user.lastName)
                .font(.system(size: 20))
            
            Spacer()
            
            if (Int(user.totalPoints) == 1) {
                Text(user.totalPoints + " pt")
                    .font(.system(size: 20))
                    .foregroundColor(Color.gray) // Set the text color to gray
            } else {
                Text(user.totalPoints + " pts")
                    .font(.system(size: 20))
                    .foregroundColor(Color.gray) // Set the text color to gray
            }
        }
        .padding(.vertical, 8)
    }
}
