//
//  LocationVerification.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/3/23.
//

import SwiftUI

struct LocationVerification: View {
    
    let serverUrl: String = "URL"
    var locationDetailStore: LocationDetailsStore;
    @State var locationVerified: Bool = false;
    @State var badLocation  = false;
    @Binding var returnBinding: Bool;
    
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
        let locationValid = distanceBetweenPoints(point1: landmark, point2: userLocation) < thresh
        
        if locationValid{
            UserDefaults.standard.set("zjweiss", forKey: "logname")
            let logname = UserDefaults.standard.string(forKey: "logname") ?? "unknown user"
            await submitValidLocation(locationId: locactionId, username: logname)
            locationVerified = true
            return
        } else {
            badLocation = true
            return
        }
        
    }
    
    func submitValidLocation(locationId: Int, username: String) async {
        let jsonObj = [
            "locationId": locationId,
            "username" : username] as [String : Any];
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
            print("login: jsonData serialization error")
            return
        }
        
        guard let apiUrl = URL(string: serverUrl+"submitcheckpoint/") else {
            print("login: Bad URL")
            return
        }
        
        var request = URLRequest(url: apiUrl)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                print("login: \(HTTPURLResponse.localizedString(forStatusCode: http.statusCode))")
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
            ZStack{
                Button {
                    //do something
                    Task{
                        var userLocation = GeoData(lat: LocManager.shared.location.coordinate.latitude, lon: LocManager.shared.location.coordinate.longitude)

                        await verifyLocation(landmark: locationDetailStore.geodata!, userLocation: userLocation, thresh: locationDetailStore.distanceThresh ?? 1, locactionId: locationDetailStore.locationID!)
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
    
    
    
    var body: some View {
        VStack{
            if let name = locationDetailStore.name {
                Spacer()
                Text(name).font(.title).bold()
                Spacer()
            }
            Spacer()
            if locationVerified {
                Text("Locaton verified").font(.title2)              .foregroundColor(.green).bold()
            }
            if badLocation && !locationVerified {
                Text("You are in the correct location\nLets try again!").font(.title2)              .foregroundColor(.red).bold()
            }
            Spacer()
            if let hasAR = locationDetailStore.hasAR{
                if hasAR{
                 // do AR stuff
                } else {
                 // show an image if there is no AR stuff
                    let displayString: String = "This is what the " +  (locationDetailStore.name ?? "location") + " looks like.\nHave you found it?";
                    Text(displayString).font(.title2)
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
