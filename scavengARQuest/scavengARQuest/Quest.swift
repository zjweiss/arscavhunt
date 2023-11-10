//
//  Quest.swift
//  ScavengARQuest
//
//  Created by Abbie Tooman on 11/7/23.
//
import Foundation

struct Quest: Identifiable{
    let id = UUID()
    let quest_id: String
    let name: String
    let quest_status: String
    var thumbnail: String
    let description: String
    let rating: String
    let estimated_time: String
    let num_incomplete_sub_quests: String
    let total_sub_quests: String
}
