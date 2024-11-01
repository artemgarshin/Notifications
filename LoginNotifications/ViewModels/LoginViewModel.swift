//
//  LoginViewModel.swift
//  LoginNotifications
//
//  Created by Артем Гаршин on 01.11.2024.
//

import Foundation
import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var loginAttempt: LoginAttemptModel?
    @Published var showConfirmation: Bool = false

    /// Функция для проверки попытки входа
    func checkLoginAttempt() {
        guard let url = URL(string: "http://localhost:8080/checkLoginAttempt?login=\(username)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Ошибка: \(error.localizedDescription)")
                return
            }
            guard let data = data else { return }
            
            if let attempt = try? JSONDecoder().decode(LoginAttemptModel.self, from: data) {
                DispatchQueue.main.async {
                    self.loginAttempt = attempt
                    self.showConfirmation = true
                }
            } else {
                print("Попытка входа не найдена или ошибка при декодировании данных.")
            }
        }.resume()
    }
    
    /// Функция для отправки решения
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
                DispatchQueue.main.async {
                    // Убираем скрытие экрана подтверждения
                }
            }
        }.resume()
    }

}
