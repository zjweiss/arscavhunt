//
//  LocManager.swift
//  scavengARQuest
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
    
    private var heading: CLHeading? = nil
    private let compass = ["North", "NE", "East", "SE", "South", "SW", "West", "NW", "North"]
    var compassHeading: String {
        return if let heading {
            compass[Int(round(heading.magneticHeading.truncatingRemainder(dividingBy: 360) / 45))]
        } else {
            "unknown"
        }
    }

    var headings: AsyncStream<CLHeading> {
           AsyncStream(CLHeading.self) { cont in
               delegate.headingStream = {
                   cont.yield($0)
               }
               cont.onTermination = { @Sendable _ in
                   self.locManager.stopUpdatingHeading()
               }
               locManager.startUpdatingHeading()
           }
       }
    
       private func startUpdates() {
           if locManager.authorizationStatus == .notDetermined {
               // ask for user permission if undetermined
               // Be sure to add 'Privacy - Location When In Use Usage Description' to
               // Info.plist, otherwise location read will fail silently,
               // with (lat/lon = 0)
               locManager.requestAlwaysAuthorization()
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
           
           Task {
               for await newHeading in headings {
                   if !isUpdating { break }
                   heading = newHeading
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
