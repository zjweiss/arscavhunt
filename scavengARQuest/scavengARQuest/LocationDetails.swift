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
    @Binding var returnBinding: Bool
    let locationID: Int
    
    private let store = ScavengarStore.shared
    
    
    // This should be the full
    
    // This is to be used by the user once they get their location verified to
    // Go back to the quest details page
    //@Binding var returnBinding: Bool;
    
    
    @ViewBuilder
    func ArrivedButton(locationID: Int) -> some View {
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
                LocationVerification(locationID: locationID, returnBinding: $returnBinding)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack{
                let locationDetailStore: Location = store.locationDict[locationID] ?? Location(quest_id: -1, location_id: -1, name: "", latitude: "", longitude: "", description: "", thumbnail: "", ar_file: "", ar_displacement: 0.0, ar_unwrap: false, distance_threshold: "", status: "", points: "", tags: "", team_code: "")
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
                    ArrivedButton(locationID: locationID)
                }
            }
        }
    }
}
