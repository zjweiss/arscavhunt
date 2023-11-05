//
//  ScavengARQuestApp.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 10/29/23.
//

import SwiftUI

@main
struct ScavengARQuestApp: App {
    var body: some Scene {
        WindowGroup {
            LocationDetails( locationDetailStore: LocationDetailsStore(name: "DOW", imageUrl: "https://brand.umich.edu/assets/brand/style-guide/logo-guidelines/Block_M-Hex.png", description: "The Herbert H. Dow Building, an architectural marvel, named after the renowned chemist Herbert H. Dow, is a focal point for students and researchers in the fields of chemistry and natural sciences. Inside, it houses advanced laboratories and collaborative spaces that foster innovation and groundbreaking discoveries. The Herbert H. Dow Building stands as a testament to the university's commitment to pushing the boundaries of knowledge and shaping the future of scientific research.", labels: "Engineering,North Campus,Herbert Dow, Quiet,Nerds,Fun", geodata: GeoData(lat: 42.293911, lon: -83.713577), hasAR: nil ))        }
    }
}
