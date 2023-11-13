//
//  LocationVerification.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/3/23.
//

import SwiftUI

struct LocationVerification: View {
    
    let serverUrl = "https://3.142.74.134"
    @Binding var locationDetailStore: Location;
    @State var locationVerified: Bool = false;
    @State var badLocation  = false;
    @Binding var returnBinding: Bool;
    @Binding var completedQuests: Int;

    
    @ViewBuilder
        func DoneButton() -> some View {
            ZStack{
                Button {
                    //do something
                    returnBinding.toggle()
                } label: {
                    Text("Done")
                        .font(.title)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .cornerRadius(30)
                        .background(Color.blue)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 0, maxHeight: .infinity)
                }
            }
        }
    
    func verifyLocation(landmark: GeoData, userLocation: GeoData, thresh: Double = 1, locactionId: Int) async {
        // distanceBetweenPoints returns the distance in km
        let distance  = distanceBetweenPoints(point1: landmark, point2: userLocation)
        print(String(distance))
        print(String(userLocation.lat) + "  " + String(userLocation.lon))
        let locationValid = distance * 1000 < thresh
        
        if locationValid{
            await submitValidLocation();
            locationVerified = true;
            locationDetailStore.status = "complete";
            completedQuests = completedQuests + 1;
            return
        } else {
            badLocation = true
            return
        }
        
    }
    
    func submitValidLocation() async {
        
        let userID: Int  = UserDefaults.standard.integer(forKey: "userID")
        let questID: Int = locationDetailStore.quest_id
        let locationID: Int = locationDetailStore.location_id
    
        
        print(serverUrl+"/users/" + String(userID) + "/quests/" + String(questID) + "/locations/" + String(locationID) + "/submit_checkpoint")
        guard let apiUrl = URL(string: serverUrl+"/users/" + String(userID) + "/quests/" + String(questID) + "/locations/" + String(locationID) + "/submit_checkpoint") else {
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
                Button {
                    //do something
                    Task{
                        let lat  = Double(locationDetailStore.latitude) ?? 0
                        let lon  = Double(locationDetailStore.longitude) ?? 0
                        let landmarkLocation = GeoData(lat: lat, lon: lon)
                        let userLocation = GeoData(lat: LocManager.shared.location.coordinate.latitude, lon: LocManager.shared.location.coordinate.longitude)
                        
                        await verifyLocation(landmark: landmarkLocation, userLocation: userLocation, thresh: (Double(locationDetailStore.distance_threshold) ?? 300.0), locactionId: locationDetailStore.location_id)
                    }
                } label: {
                    Text("Verify Location")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                        .padding(.vertical, 30)
                        .cornerRadius(30)
                        .background(Color.blue)
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 0, maxHeight: .infinity)
                }
            }
        }
        }
    
    
    
    var body: some View {
        VStack{
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
                Text("You are not in the correct location\nLets try again!").font(.title2)
                    .foregroundColor(.red)
                    .bold()
            }
            Spacer()
            if locationDetailStore.ar_enabled{
                 // do AR stuff
                 // will be implemented in MVP
                } else {
                 // show an image if there is no AR stuff
                    let displayString: String = "This is what the " +  (locationDetailStore.name) + " looks like.\nHave you found it?";
                    Text(displayString).font(.title2)
                    if let imageUrl = URL(string: locationDetailStore.thumbnail) {
                        AsyncImage(url: imageUrl){
                            $0.resizable().scaledToFit()
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 300, height: 200)
                    }
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
