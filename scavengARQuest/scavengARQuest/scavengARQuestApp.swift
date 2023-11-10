//
//  ScavengARQuestApp.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 10/29/23.
//

import SwiftUI

@main
struct ScavengARQuestApp: App {
    init() {
        QuestList.shared.getQuests()
    }
    var body: some Scene {
        WindowGroup {
        LoginView()
        }
    }
}
