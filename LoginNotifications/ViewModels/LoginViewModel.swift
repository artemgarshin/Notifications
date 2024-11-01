//
//  LoginViewModel.swift
//  LoginNotifications
//
//  Created by Артем Гаршин on 01.11.2024.
//

import Foundation
import Combine
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var loginAttempt: LoginAttemptModel? {
        didSet {
            // Открываем экран подтверждения, если пришёл новый запрос
            if loginAttempt != nil {
                showConfirmation = true
            }
        }
    }
    @Published var showConfirmation: Bool = false

    private var timer: AnyCancellable?

    func startCheckingForUpdates() {
        timer = Timer.publish(every: 5, on: .main, in: .default)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkLoginAttempt()
            }
    }
    
    func stopCheckingForUpdates() {
        timer?.cancel()
        timer = nil
    }

    func checkLoginAttempt() {
        guard let url = URL(string: "http://localhost:8080/checkLoginAttempt?login=\(username)") else { return }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            if let attempt = try? JSONDecoder().decode(LoginAttemptModel.self, from: data) {
                DispatchQueue.main.async {
                    self?.loginAttempt = attempt
                }
            } else {
                DispatchQueue.main.async {
                    // Оставляем `showConfirmation` открытым, если он уже открыт
                    if self?.showConfirmation == true {
                        self?.loginAttempt = nil
                    } else {
                        self?.showConfirmation = false
                    }
                }
                print("Попытка входа не найдена или ошибка при декодировании данных.")
            }
        }.resume()
    }

    func submitDecision(approved: Bool) {
        guard let url = URL(string: "http://localhost:8080/submitDecision") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let decision = DecisionModel(login: username, decision: approved ? "allow" : "deny")
        request.httpBody = try? JSONEncoder().encode(decision)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            if let responseMessage = try? JSONDecoder().decode([String: String].self, from: data) {
                print("Ответ от сервера: \(responseMessage)")
            }
        }.resume()
    }
}
