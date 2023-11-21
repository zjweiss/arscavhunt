//
//  ScavengarStore.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/21/23.
//

import Foundation

@Observable
final class ScavengarStore {
    static let shared = ScavengarStore() // create one instance of the class to be shared
    private init() {}                // and make the constructor private so no other
    // instances can be created
    //@Published
    private(set) var quests = [Quest]()
    private questLocationDict = [Int: [Location]]()
    private let serverUrl = "https://3.142.74.134"

    
    func postChatt(_ chatt: Chatt, image: UIImage?, videoUrl: URL?) async -> Data? {
        guard let apiUrl = URL(string: serverUrl+"postimages/") else {
            print("postChatt: Bad URL")
            return nil
        }
        
        return try? await AF.upload(multipartFormData: { mpFD in
            if let username = chatt.username?.data(using: .utf8) {
                mpFD.append(username, withName: "username")
            }
            if let message = chatt.message?.data(using: .utf8) {
                mpFD.append(message, withName: "message")
            }
            if let jpegImage = image?.jpegData(compressionQuality: 1.0) {
                mpFD.append(jpegImage, withName: "image", fileName: "chattImage", mimeType: "image/jpeg")
            }
            if let videoUrl { //urlString = chatt.videoUrl, let videoUrl = URL(string: urlString) {
                mpFD.append(videoUrl, withName: "video", fileName: "chattVideo", mimeType: "video/mp4")
            }
        }, to: apiUrl, method: .post).validate().serializingData().value
    }
    
    
    
    func getChatts() {
        guard let apiUrl = URL(string: serverUrl+"getimages/") else {
            print("getChatts: bad URL")
            return
        }
        
        AF.request(apiUrl, method: .get).responseData { response in
            guard let data = response.data, response.error == nil else {
                print("getChatts: NETWORKING ERROR")
                return
            }
            if let httpStatus = response.response, httpStatus.statusCode != 200 {
                print("getChatts: HTTP STATUS: \(httpStatus.statusCode)")
                return
            }
            guard let jsonObj = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                print("getChatts: failed JSON deserialization")
                return
            }
            let chattsReceived = jsonObj["chatts"] as? [[String?]] ?? []
            self.chatts = [Chatt]()
            for chattEntry in chattsReceived {
                if (chattEntry.count == self.nFields) {
                    self.chatts.append(Chatt(username: chattEntry[0],
                                             message: chattEntry[1],
                                             timestamp: chattEntry[2],
                                             imageUrl: chattEntry[3],
                                             videoUrl: chattEntry[4]))
                } else {
                    print("getChatts: Received unexpected number of fields: \(chattEntry.count) instead of \(self.nFields).")
                }
            }
        }
    }
    
}
