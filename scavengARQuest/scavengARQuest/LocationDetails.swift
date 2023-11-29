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
    @Binding var locationDetailStore: Location;
    @Binding var completedQuests: Int

    // This should be the full
    
    // This is to be used by the user once they get their location verified to
    // Go back to the quest details page
    //@Binding var returnBinding: Bool;
    
    
    @ViewBuilder
    func ArrivedButton() -> some View {
        ZStack{
            Button {
                hasArrived.toggle()
            } label: {
                Text("I've arrived?")
                    .font(.title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 100)
                    .padding(.vertical, 10)
                    .background(Color(red: 23/255, green: 37/255, blue: 84/255))
                    .cornerRadius(5)
            } .navigationDestination(isPresented: $hasArrived) {
                LocationVerification(locationDetailStore: $locationDetailStore, returnBinding: $hasArrived, completedQuests: $completedQuests)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var body: some View {
        NavigationStack {
        VStack{
            Text(locationDetailStore.name).bold().font(.title).padding(.top, 20)
            Text(locationDetailStore.points + " Points").font(.subheadline).foregroundColor(.gray).bold()
            if let imageUrl = URL(string: locationDetailStore.thumbnail) {
                AsyncImage(url: imageUrl){
                    $0.resizable().scaledToFill()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 370, height: 237)
                .cornerRadius(10.0)
            }
            Spacer()
            KeywordTag(keywords: locationDetailStore.tags )
            Spacer()
            Text(locationDetailStore.description).padding(.horizontal, 30)
            Spacer()
            Button {
                cameraPosition = .camera(MapCamera(
                    centerCoordinate: CLLocationCoordinate2D(latitude: Double(locationDetailStore.latitude) ?? 0, longitude: Double(locationDetailStore.longitude) ?? 0), distance: 500, heading: 0, pitch: 60))
                isMapping.toggle()
            } label: {
                HStack {
                    Image(systemName: "mappin.and.ellipse").scaleEffect(2).padding(.top, 20).offset(x: -20)
                    Text("Need a hint?")
                        .baselineOffset(-25) // Adjust the value to move the text up or down
                }
//                .padding(.top, 20.0)
            }
            .padding(.bottom, 20)
            .navigationDestination(isPresented: $isMapping) {
                MapView(cameraPosition: $cameraPosition, locationDetails: locationDetailStore)
            }
            
            Spacer()
            if (locationDetailStore.status != "complete"){
                ArrivedButton()
            }
        }
    }
    }
}



/*
struct LocationDetails_Preview: PreviewProvider {
    static var previews: some View {
        LocationDetails( locationDetailStore: LocationDetailsStore(name: "DOW", imageUrl: "https://brand.umich.edu/assets/brand/style-guide/logo-guidelines/Block_M-Hex.png", description: "The Herbert H. Dow Building, an architectural marvel, named after the renowned chemist Herbert H. Dow, is a focal point for students and researchers in the fields of chemistry and natural sciences. Inside, it houses advanced laboratories and collaborative spaces that foster innovation and groundbreaking discoveries. The Herbert H. Dow Building stands as a testament to the university's commitment to pushing the boundaries of knowledge and shaping the future of scientific research.", labels: "Engineering,North Campus,Herbert Dow, Quiet,Nerds,Fun", geodata: GeoData(lat: 42.293911, lon: -83.713577) ), returnBinding: Binding<Bool>)
    }
}
*/
