//
//  LoginView.swift
//  LoginNotifications
//
//  Created by Артем Гаршин on 01.11.2024.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                TextField("Введите логин", text: $viewModel.username)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .padding(.horizontal)
                
                Button(action: {
                    viewModel.checkLoginAttempt()
                    viewModel.showConfirmation = true
                }) {
                    Text("Войти")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .fullScreenCover(isPresented: $viewModel.showConfirmation) {
            ConfirmationView(viewModel: viewModel)
        }
    }
}
