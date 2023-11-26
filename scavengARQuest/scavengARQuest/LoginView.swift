//
//  LoginView.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/5/23.
//

import SwiftUI

struct LoginView: View {
    
    private var serverUrl = "https://3.142.74.134"
    @State private var username = "Enter your username here"
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
            Text("Welcome to\nScavengAR Quest").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold().multilineTextAlignment(.center)
            if store.username != "" {
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
                
                Spacer().padding(.bottom,100)
                Text("Enter your username\nbelow to log in:").multilineTextAlignment(.center).bold().font(.title2)
                Spacer()
                TextEditor(text: $username)
                SubmitButton()
            }
        }
    }
}

#Preview {
    LoginView()
}
