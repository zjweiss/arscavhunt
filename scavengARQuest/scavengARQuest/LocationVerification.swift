//
//  LocationVerification.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/3/23.
//

import SwiftUI

struct LocationVerification: View {
    
    let serverUrl = "https://3.142.74.134"
    @State var locationVerified: Bool = false;
    @State var badLocation  = false;
    @State var displayAR: Bool = false
    let locationID: Int
    @Binding var returnBinding: Bool
    private let store = ScavengarStore.shared


    
    @ViewBuilder
        func DoneButton() -> some View {
            ZStack{
                Button {
                    returnBinding.toggle()
                } label: {
                    Text("Done")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 100)
                        .padding(.vertical, 10)
                        .background(Color(red: 23/255, green: 37/255, blue: 84/255))
                        .cornerRadius(5)
                }
            }
        }

    @ViewBuilder
    func ARButton() -> some View {
        ZStack{
            Button {
                displayAR.toggle()
            } label: {
                Text("Let's celebrate with some AR!")
                    .font(.title3)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 100)
                    .padding(.vertical, 10)
                    .background(Color(red: 23/255, green: 37/255, blue: 84/255))
                    .cornerRadius(5)
            }
            .navigationDestination(isPresented: $displayAR) {
                ARView()
            }
        }
    }
    
    func verifyLocation(landmark: GeoData, userLocation: GeoData, thresh: Double = 1, locactionId: Int, questID: Int) async {
        // distanceBetweenPoints returns the distance in km
        let distance  = distanceBetweenPoints(point1: landmark, point2: userLocation)
        store.filename = store.locationDict[locationID]?.ar_file ?? ""
        store.ar_unwrap = store.locationDict[locationID]?.ar_unwrap ?? false
        store.ar_displacement = store.locationDict[locationID]?.ar_displacement ?? 0.0

        
        print(String(distance))
        print(String(userLocation.lat) + "  " + String(userLocation.lon))
        let locationValid = distance * 1000 < thresh
        
        if locationValid{
            await submitValidLocation();

            do {
                try await store.getQuests()
                try await store.getActiveQuestLocations(questID: questID)
                try await store.getOtherTeamates(questID: questID)
            } catch RequestError.invalidData {
                print("Invalid Data")
            } catch RequestError.invalidResponse {
                print("Invalid Response")
            } catch RequestError.invalidUrl {
                print("Invalid URL")
            } catch {
                print("Unexpected API error")
            }
            
            locationVerified = true
            return
        } else {
            badLocation = true
            return
        }
        
    }
    
    func submitValidLocation() async {
        
        
        let locationDetailStore = store.locationDict[locationID] ?? Location(quest_id: -1, location_id: -1, name: "", latitude: "", longitude: "", description: "", thumbnail: "", ar_file: "", distance_threshold: "", status: "", points: "", tags: "", team_code: "")
        let questID: Int = locationDetailStore.quest_id
        let locationID: Int = locationDetailStore.location_id
        let team_code = locationDetailStore.team_code
        
        print(serverUrl+"/teams/" + team_code + "/quests/" + String(questID) + "/locations/" + String(locationID) + "/submit_checkpoint")
        guard let apiUrl = URL(string: serverUrl+"/teams/" + team_code + "/quests/" + String(questID) + "/locations/" + String(locationID) + "/submit_checkpoint") else {
            print("login: Bad URL")
            return
        }

        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                print(String(http.statusCode))
                print("submit checkpoint: \(HTTPURLResponse.localizedString(forStatusCode: http.statusCode))")
                return
            }
        } catch {
            print("login: NETWORKING ERROR")
        }
        return
    }
        
    
    
    @ViewBuilder
    @MainActor
    func VerifyButton() -> some View {
        NavigationView{
            ZStack{
                let locationDetailStore = store.locationDict[locationID] ?? Location(quest_id: -1, location_id: -1, name: "", latitude: "", longitude: "", description: "", thumbnail: "", ar_file: "", distance_threshold: "", status: "", points: "", tags: "", team_code: "")
                Button {
                    //do something
                    Task{
                        let lat  = Double(locationDetailStore.latitude) ?? 0
                        let lon  = Double(locationDetailStore.longitude) ?? 0
                        let landmarkLocation = GeoData(lat: lat, lon: lon)
                        let userLocation = GeoData(lat: LocManager.shared.location.coordinate.latitude, lon: LocManager.shared.location.coordinate.longitude)
                        
                        await verifyLocation(landmark: landmarkLocation, userLocation: userLocation, thresh: (Double(locationDetailStore.distance_threshold) ?? 300.0), locactionId: locationDetailStore.location_id, questID: locationDetailStore.quest_id)
                    }
                } label: {
                    Text("Verify Location")
                        .font(.title3)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 100)
                        .padding(.vertical, 10)
                        .background(Color(red: 23/255, green: 37/255, blue: 84/255))
                        .cornerRadius(5)
                }
            }
        }
        }
    
    
    
    var body: some View {
        VStack{
            let locationDetailStore = store.locationDict[locationID] ?? Location(quest_id: -1, location_id: -1, name: "", latitude: "", longitude: "", description: "", thumbnail: "", ar_file: "", distance_threshold: "", status: "", points: "", tags: "", team_code: "")
                Spacer()
                Text(locationDetailStore.name).font(.title).bold()
                Spacer()
            Spacer()
            if locationVerified {
                Text("Locaton verified")
                    .font(.title2)
                    .foregroundColor(.green)
                    .bold()
            }
            if badLocation && !locationVerified {
                Text("You are not in the correct location\nLets try again!\nHint: Check out the map on the previous page to see the location!").font(.title2)
                    .foregroundColor(.red)
                    .bold()
            }
            Spacer()
            if !locationVerified{
                 // show an image if there is pre verification
                    let displayString: String = "This is what the " +  (locationDetailStore.name) + " looks like.\nHave you found it?";
                    Text(displayString).font(.subheadline)
                    if let imageUrl = URL(string: locationDetailStore.thumbnail) {
                        AsyncImage(url: imageUrl){
                            $0.resizable().scaledToFill()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 370, height: 237)
                        .cornerRadius(10.0)
                    }
                }
            
                if locationVerified && locationDetailStore.ar_file != "" {
                    ARButton()
            }
            
            
            
            Spacer()
            if locationVerified{
                // show done button
                DoneButton()
            } else {
                // show verify location button
                VerifyButton()
            }
            
        }
        .navigationTitle("Location Verification")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { LocManager.shared.toggleUpdates() }
        .onDisappear { LocManager.shared.toggleUpdates() }
    }
}
/*
#Preview {
    LocationVerification( locationDetailStore: LocationDetailsStore(locationID: 33, name: "DOW", imageUrl: "https://brand.umich.edu/assets/brand/style-guide/logo-guidelines/Block_M-Hex.png", description: "The Herbert H. Dow Building, an architectural marvel, named after the renowned chemist Herbert H. Dow, is a focal point for students and researchers in the fields of chemistry and natural sciences. Inside, it houses advanced laboratories and collaborative spaces that foster innovation and groundbreaking discoveries. The Herbert H. Dow Building stands as a testament to the university's commitment to pushing the boundaries of knowledge and shaping the future of scientific research.", labels: "Engineering,North Campus,Herbert Dow, Quiet,Nerds,Fun", geodata: GeoData(lat: -26.204102800000001, lon: 28.047305), hasAR: false, distanceThresh: 0.3 ))
}
*/
