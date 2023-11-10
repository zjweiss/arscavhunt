//
//  LoginView.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/5/23.
//

import SwiftUI

// To get the currently logged in user's username, see example below:
// The user should only have to log in 1 time per downloading the app
// let userId = UserDefaults.standard.integer(forKey: "userID")
// let logname = UserDefaults.standard.string(forKey: "logname")





struct LoginView: View {
    
    private var serverUrl = "https://3.142.74.134"
    @State private var username = "Enter your username here"
    @State private var status = LoginStatus.pending
    @State private var loginDone = false
    
    enum LoginStatus {
         case pending, success, invalid
     }
    
    
    func submitLogin() async {
               let jsonObj = ["username": username]
               guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonObj) else {
                   print("login: jsonData serialization error")
                   return
               }
                       
               guard let apiUrl = URL(string: serverUrl+"/login/") else {
                   print("login: Bad URL")
                   return
               }
               
               var request = URLRequest(url: apiUrl)
               request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
               request.httpMethod = "POST"
               request.httpBody = jsonData

               do {
                   let (data, response) = try await URLSession.shared.data(for: request)
                   if let http = response as? HTTPURLResponse, http.statusCode != 200 {
                       print("login: \(HTTPURLResponse.localizedString(forStatusCode: http.statusCode))")
                   } else {
                       //process the returned response
                       guard let jsonResponse = try? JSONSerialization.jsonObject(with: data) as? [String:Any] else {
                                    print("login response: failed JSON deserialization")
                                    return
                                }
                       
                       if jsonResponse["status"] as! String == "validUser"{
                           let defaults = UserDefaults.standard
                           
                           if let userArray = jsonResponse["user"] as? [Any] {
                               let firstName = userArray[1] as? String ?? ""
                               let lastName = userArray[2] as? String ?? ""
                               let userID = userArray[0] as? Int ?? 0
                               let canolicalName = firstName + " " + lastName
                               defaults.set(canolicalName, forKey: "canName")
                               defaults.set(userID, forKey: "userID")

                           }
                           defaults.set(username, forKey: "logname")
                           status = LoginStatus.success
                           loginDone.toggle()
                       } else{
                           status = LoginStatus.invalid
                       }
                       return
                   }
               } catch {
                   print("login: NETWORKING ERROR")
               }
               return
           }
    
    
    
    @ViewBuilder
    func SubmitButton() -> some View {
        ZStack{
            Button {
                //do something
                Task{
                    await submitLogin()
                }
            } label: {
                Text("Submit")
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
            Spacer()
            Text("Welcome to\nScavengAR Quest").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()                .multilineTextAlignment(.center)
            if status == LoginStatus.invalid {
                // display something stating that login is invalid
                Spacer()
                Text("Invalid username")
                    .foregroundColor(Color.red)
                    .bold()
                    .font(.title2)
                Text("Please try again")
                    .foregroundColor(Color.red)
                    .bold()
                    .font(.title2)
            }
            
            Spacer().padding(.bottom,100)
            Text("Enter your username\nbelow to log in:").multilineTextAlignment(.center).bold().font(.title2)
            Spacer()
            TextEditor(text: $username)
            SubmitButton()
        }
        .fullScreenCover(isPresented: $loginDone, content: {
            ContentView()
        })
    }
}

#Preview {
    LoginView()
}
