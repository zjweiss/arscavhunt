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
    var locationDetailStore: Location;
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
            } .navigationDestination(isPresented: $hasArrived) {
                LocationVerification(locationDetailStore: locationDetailStore, returnBinding: $hasArrived)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var body: some View {
        NavigationStack {
        VStack{
            Spacer()
            Text(locationDetailStore.name).bold().font(.title).padding(.vertical, 20)
            Text(locationDetailStore.points + " Points").font(.title2).foregroundColor(.gray).bold()
            if let imageUrl = URL(string: locationDetailStore.thumbnail) {
                AsyncImage(url: imageUrl){
                    $0.resizable().scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 300, height: 200)
            }
            Spacer()
            KeywordTag(keywords: locationDetailStore.tags )
            Spacer()
            Text(locationDetailStore.description)
            Spacer()
            Button {
                cameraPosition = .camera(MapCamera(
                    centerCoordinate: CLLocationCoordinate2D(latitude: Double(locationDetailStore.latitude) ?? 0, longitude: Double(locationDetailStore.longitude) ?? 0), distance: 500, heading: 0, pitch: 60))
                isMapping.toggle()
            } label: {
                Image(systemName: "mappin.and.ellipse").scaleEffect(2.5).padding(.top, 20)
            }
            .navigationDestination(isPresented: $isMapping) {
                MapView(cameraPosition: $cameraPosition, locationDetails: locationDetailStore)
            }
            
            Spacer()
            ArrivedButton()
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
