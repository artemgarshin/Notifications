//
//  ConfirmationView.swift
//  LoginNotifications
//
//  Created by Артем Гаршин on 01.11.2024.
//

import SwiftUI

struct ConfirmationView: View {
    @ObservedObject var viewModel: LoginViewModel
    let loginAttempt: LoginAttemptModel

    @State private var requestApproved: Bool? = nil
    @State private var borderColor: Color = Color.gray.opacity(0.5)
    @State private var showWaitingIcon = false
    @State private var showNewScreen = false

    var body: some View {
        ZStack {
            
            LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]),
                           startPoint: .top,
                           endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showNewScreen = true 
                        }
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.white)
                            .padding()
                    }
                    Spacer()
                }

                Spacer()

                Circle()
                    .fill(Color.gray.opacity(0.7))
                    .frame(width: 300, height: 300)
                    .overlay(
                        VStack {
                            if showWaitingIcon {
                                Image(systemName: "hourglass")
                                    .font(.system(size: 64))
                                    .foregroundColor(.white)
                            } else if let approved = requestApproved {
                                Text(approved ? "Approved!" : "Denied!")
                                    .foregroundColor(approved ? .green : .red)
                                    .font(.title)
                            } else {
                                Text("Login: \(loginAttempt.login)")
                                    .foregroundColor(.blue)
                                    .font(.largeTitle)
                                Text("Browser: \(loginAttempt.browser)")
                                    .foregroundColor(.white)
                                Text("OS: \(loginAttempt.operatingSystem)")
                                    .foregroundColor(.white)
                                Text("IP: \(loginAttempt.ipAddress)")
                                    .foregroundColor(.white)
                            }
                        }
                    )
                    .overlay(
                        Circle()
                            .stroke(borderColor, lineWidth: 4)
                    )
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 5)

                HStack {
                    Button(action: {
                        handleDecision(approved: true)
                    }) {
                        Text("Approve")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        handleDecision(approved: false)
                    }) {
                        Text("Deny")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                }
                Spacer()
            }
            .padding()

            
            if showNewScreen {
                LoginView()
                    .transition(.move(edge: .trailing))
            }
        }
    }

    private func handleDecision(approved: Bool) {
        viewModel.submitDecision(approved: approved)
        borderColor = approved ? Color.green : Color.red
        requestApproved = approved
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            borderColor = Color.gray.opacity(0.5)
            requestApproved = nil
            showWaitingIcon = true
        }
    }
}
