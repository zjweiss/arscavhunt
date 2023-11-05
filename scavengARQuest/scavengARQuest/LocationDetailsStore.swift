//
//  LocationDetailsStore.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/1/23.
//

import Foundation

// Stores all the basic info for one particular location
struct LocationDetailsStore {
    var locationID: Int?
    var name: String?
    var imageUrl: String?
    var description: String?
    var labels: String?
    var geodata: GeoData?
    var hasAR: Bool?
    var distanceThresh: Double?
}
