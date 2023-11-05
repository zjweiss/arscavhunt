//
//  LocationDetails.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/1/23.
//

import Foundation
import SwiftUI
import _MapKit_SwiftUI

struct LocationDetails: View {
    
    
    @State var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @State var isMapping = false
    @State var hasArrived = false
    var locationDetailStore: LocationDetailsStore;
    
    
    @ViewBuilder
        func ArrivedButton() -> some View {
            ZStack{
                Button {
                    hasArrived.toggle()
                } label: {
                    Text("I'VE ARRIVED")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 70)
                    .padding(.vertical, 30)
                    .cornerRadius(30)
                    .background(Color.blue)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 0, maxHeight: .infinity)
                } .fullScreenCover(isPresented: $hasArrived) {
                    LocationVerification(locationDetailStore: locationDetailStore)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    
    
    
    
    var body: some View {
        VStack{
            HStack{
                
            }
            Spacer()
            if let locationName = locationDetailStore.name {
                Text(locationName).bold().font(.title).padding(.vertical, 20)
            }
            Spacer()
            if let urlString = locationDetailStore.imageUrl, let imageUrl = URL(string: urlString) {
                AsyncImage(url: imageUrl){
                    $0.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 200)
            }
            Spacer()
            if let keywords = locationDetailStore.labels {
                KeywordTag(keywords: keywords)
            }
            Spacer()
            if let description = locationDetailStore.description{
                Text(description)
            }
            Spacer()
            if let geodata = locationDetailStore.geodata {
                                    Button {
                                        cameraPosition = .camera(MapCamera(
                                            centerCoordinate: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon), distance: 500, heading: 0, pitch: 60))
                                        isMapping.toggle()
                                    } label: {
                                        Image(systemName: "mappin.and.ellipse").scaleEffect(2.5).padding(.top, 20)
                                    }
                                    .fullScreenCover(isPresented: $isMapping) {
                                                MapView(cameraPosition: $cameraPosition, locationDetails: locationDetailStore)
                                            }
                                    
                                                          } // end chat geodata
            Spacer()
            ArrivedButton()
                            }
      
        }
        
        
    }




struct LocationDetails_Preview: PreviewProvider {
    static var previews: some View {
        LocationDetails( locationDetailStore: LocationDetailsStore(name: "DOW", imageUrl: "https://brand.umich.edu/assets/brand/style-guide/logo-guidelines/Block_M-Hex.png", description: "The Herbert H. Dow Building, an architectural marvel, named after the renowned chemist Herbert H. Dow, is a focal point for students and researchers in the fields of chemistry and natural sciences. Inside, it houses advanced laboratories and collaborative spaces that foster innovation and groundbreaking discoveries. The Herbert H. Dow Building stands as a testament to the university's commitment to pushing the boundaries of knowledge and shaping the future of scientific research.", labels: "Engineering,North Campus,Herbert Dow, Quiet,Nerds,Fun", geodata: GeoData(lat: 42.293911, lon: -83.713577) ))
    }
}
