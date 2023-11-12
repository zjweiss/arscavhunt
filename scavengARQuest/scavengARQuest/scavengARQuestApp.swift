//
//  ScavengARQuestApp.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 10/29/23.
//

import SwiftUI

@main
struct ScavengARQuestApp: App {
    @State var questId: Int = 1
    @State var questName: String = "Campus Study Spots"
    @State var complete: Int = 1
    @State var incomplete: Int = 6
    
    var body: some Scene {
        WindowGroup {
            ActiveQuestPage(
                questId: $questId,
                questName: $questName,
                incomplete: $incomplete,
                complete: $complete
            )
        }
    }
}
