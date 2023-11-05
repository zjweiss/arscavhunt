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
func distanceBetweenPoints(point1: GeoData, point2: GeoData) -> Double {
    
    var lat1: Double = point1.lat / 57.29577951
    var lon1: Double = point1.lon / 57.29577951
    var lat2: Double = point2.lat / 57.29577951
    var lon2: Double = point2.lon / 57.29577951
    
    var distLong: Double = lon2 - lon1;
    var distLat: Double = lat2 - lat1;
    var ans: Double = 0

    ans = pow(sin(distLat / 2), 2) + cos(lat1) * cos(lat2) * pow(sin(distLong / 2), 2);
    ans = 2 * asin(sqrt(ans));
    
    var R: Double = 6371;
    
    return ans * R;
    
}
