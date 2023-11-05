//
//  LocationVerification.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/3/23.
//

import SwiftUI

struct LocationVerification: View {
    
    var locationDetailStore: LocationDetailsStore;
    @State var locationVerified: Bool = false
    
    var body: some View {
        VStack{
            if let name = locationDetailStore.name{
                Spacer()
                Text(name).font(.title).bold()
                Spacer()
            }
            Spacer()
            if locationVerified{
                Text("Locaton verified").font(.title2)              .foregroundColor(.green).bold()
            }
            Spacer()
            if let hasAR = locationDetailStore.hasAR{
                if hasAR{
                 // do AR stuff
                } else {
                 // show an image if there is no AR stuff
                 if let urlString = locationDetailStore.imageUrl, let imageUrl = URL(string: urlString) {
                        AsyncImage(url: imageUrl){
                            $0.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                    }
                }
            }
            Spacer()
            
        }
    }
}

#Preview {
    LocationVerification( locationDetailStore: LocationDetailsStore(name: "DOW", imageUrl: "https://brand.umich.edu/assets/brand/style-guide/logo-guidelines/Block_M-Hex.png", description: "The Herbert H. Dow Building, an architectural marvel, named after the renowned chemist Herbert H. Dow, is a focal point for students and researchers in the fields of chemistry and natural sciences. Inside, it houses advanced laboratories and collaborative spaces that foster innovation and groundbreaking discoveries. The Herbert H. Dow Building stands as a testament to the university's commitment to pushing the boundaries of knowledge and shaping the future of scientific research.", labels: "Engineering,North Campus,Herbert Dow, Quiet,Nerds,Fun", geodata: GeoData(lat: 42.293911, lon: -83.713577), hasAR: false ))
}

