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
    var locationDetailStore: LocationDetailsStore? = nil;
    var urlString2: String? = "https://brand.umich.edu/assets/brand/style-guide/logo-guidelines/Block_M-Hex.png";
    var descriptionString: String = "The Herbert H. Dow Building, an architectural marvel, named after the renowned chemist Herbert H. Dow, is a focal point for students and researchers in the fields of chemistry and natural sciences. Inside, it houses advanced laboratories and collaborative spaces that foster innovation and groundbreaking discoveries. The Herbert H. Dow Building stands as a testament to the university's commitment to pushing the boundaries of knowledge and shaping the future of scientific research.";
    
    
    @ViewBuilder
        func ArrivedButton() -> some View {
            ZStack{
                Button {
                } label: {
                    Text("I'VE ARRIVED")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 70)
                    .padding(.vertical, 30)
                    .cornerRadius(30)
                    .background(Color.blue)
                    .frame(maxWidth: .infinity) // Fill available horizontal space
                    .frame(minHeight: 0, maxHeight: .infinity) // Vertically centered
                    
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
    
    
    
    
    var body: some View {
        VStack{
            HStack{
                
            }
            Spacer()
            Text("DOW")
            Spacer()
            if let urlString = urlString2, let imageUrl = URL(string: urlString) {
                AsyncImage(url: imageUrl){
                    $0.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 300)
            }
            Spacer()
            KeywordTag(keywords: "Swift, SwiftUI, Tags, Example")
            Spacer()
            Text(descriptionString)
            Spacer()
            if let geodata = locationDetailStore.geodata {
                                    Button {
                                        cameraPosition = .camera(MapCamera(
                                            centerCoordinate: CLLocationCoordinate2D(latitude: geodata.lat, longitude: geodata.lon), distance: 500, heading: 0, pitch: 60))
                                        isMapping.toggle()
                                    } label: {
                                        Image(systemName: "mappin.and.ellipse").scaleEffect(1.5)
                                    }
                                    .navigationDestination(isPresented: $isMapping) {
                                                MapView(cameraPosition: $cameraPosition, locationDetails: LocationDetailsStore?)
                                            }
                                    
                                                          } // end chat geodata
                                
                            }
            Spacer()
            ArrivedButton()
        }
        
        
    }
}



struct LocationDetails_Preview: PreviewProvider {
    static var previews: some View {
        LocationDetails()
    }
}
