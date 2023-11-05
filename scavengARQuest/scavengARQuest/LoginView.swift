//
//  LoginView.swift
//  ScavengARQuest
//
//  Created by Zachary Weiss on 11/5/23.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack{
            Spacer()
            Text("Welcome to\nScavengAR Quest").font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).bold()                .multilineTextAlignment(.center)
            Spacer()
            Text("Enter your username\nbelow to log in:").multilineTextAlignment(.center).bold().font(.title2)
            Spacer()
            

        }
    }
}

#Preview {
    LoginView()
}
