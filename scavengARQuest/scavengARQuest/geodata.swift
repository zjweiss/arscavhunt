//
//  geodata.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/1/23.
//

import Foundation
import MapKit

struct GeoData: Hashable {
    var lat: Double = 0.0
    var lon: Double = 0.0
}


// The distance between two GPS points alogorithm was inspired by:
// www.geeksforgeeks.org/program-distance-two-points-earth/
// Returns the distance in km
func distanceBetweenPoints(point1: GeoData, point2: GeoData) -> Double {
    
    let lat1: Double = point1.lat / 57.29577951
    let lon1: Double = point1.lon / 57.29577951
    let lat2: Double = point2.lat / 57.29577951
    let lon2: Double = point2.lon / 57.29577951
    
    let distLong: Double = lon2 - lon1;
    let distLat: Double = lat2 - lat1;
    var ans: Double = 0

    ans = pow(sin(distLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(distLong / 2), 2);
    ans = 2 * asin(sqrt(ans));
    
    let R: Double = 6371;
    
    return ans * R;
    
}
