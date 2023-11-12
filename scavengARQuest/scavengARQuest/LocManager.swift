//
//  LocManager.swift
//  swiftUIChatter
//
//  Created by Zachary Weiss on 10/24/23.
//

import Foundation
import MapKit
import Observation


@MainActor
@Observable
final class LocManager {
    static let shared = LocManager()
    private let locManager = CLLocationManager()
    @ObservationIgnored let delegate = LocDelegate()
    
    private init() {
        // configure the location manager
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.delegate = delegate
    }
    
    private(set) var location = CLLocation()
    private(set) var isUpdating = false
    
       private func startUpdates() {
           if locManager.authorizationStatus == .notDetermined {
               // ask for user permission if undetermined
               // Be sure to add 'Privacy - Location When In Use Usage Description' to
               // Info.plist, otherwise location read will fail silently,
               // with (lat/lon = 0)
               locManager.requestWhenInUseAuthorization()
           }
       
           Task {
               do {
                   for try await update in CLLocationUpdate.liveUpdates() {
                       if !isUpdating { break }
                       location = update.location ?? location
                   }
               } catch {
                   print(error.localizedDescription)
               }
           }
       }
       
       func toggleUpdates() {
           isUpdating.toggle()
           if (isUpdating) {
               startUpdates()
           }
       }
    
    
}


final class LocDelegate: NSObject, CLLocationManagerDelegate {
    
    var headingStream: ((CLHeading) -> Void)?

    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingStream?(newHeading)
    }
    
}
