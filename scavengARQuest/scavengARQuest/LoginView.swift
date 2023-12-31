//
//  LoginView.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/5/23.
//

import SwiftUI

struct LoginView: View {
    
    private var serverUrl = "https://3.142.74.134"
    @State private var username = "Enter username here"
    @State private var status = LoginStatus.pending
    private let store = ScavengarStore.shared

    enum LoginStatus {
         case pending, success, invalid
     }
    
    @ViewBuilder
    func SubmitButton() -> some View {
        ZStack{
            Button {
                //do something
                Task{
                    let loginStat = await store.submitLogin(inputUsername: username)
                    if loginStat == 1 {
                        status = LoginStatus.success
                    } else {
                        status = LoginStatus.invalid
                    }
                }
            } label: {
                Text("Login")
                    .font(.subheadline)
                    .foregroundColor(Color(red: 23 / 255.0, green: 37 / 255.0, blue: 84 / 255.0))
                    .padding(.horizontal, 75)
                    .padding(.vertical, 15)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color(red: 23 / 255.0, green: 37 / 255.0, blue: 84 / 255.0), lineWidth: 2) // Blue outline
                    )
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: 0, maxHeight: .infinity)
                    .cornerRadius(30) // Rounded corners
            }
        }
    }
    
    var body: some View {
        VStack{
            ZStack {
                Color(red: 23 / 255.0, green: 37 / 255.0, blue: 84 / 255.0)
                    .frame(maxWidth: .infinity)
                    .frame(height: 100)
                Text("ScavangAR")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .bold()
            }
            .padding(.bottom, 30)
            
            Text("Login")
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color(red: 23 / 255.0, green: 37 / 255.0, blue: 84 / 255.0))
            Divider()
            
            if !store.username.trimmingCharacters(in: .whitespaces).isEmpty {
                Spacer()
                Text("You are successfully logged in, \(store.username)!")
                    .foregroundColor(Color.green)
                    .bold()
                    .font(.title2)
                Spacer()
            } else {
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
                
                Spacer().padding(.bottom, 20)
                HStack {
                    Text("Username")
                        .bold()
                        .padding(.leading, 20) // Added left padding
                        .frame(maxWidth: .infinity, alignment: .leading) // Align text to the left
                }
                    TextEditor(text: $username)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .padding(.all, 20)
                    Divider().padding(.horizontal, 20)
                SubmitButton()
            }
        }
    }
}

#Preview {
    LoginView()
}
