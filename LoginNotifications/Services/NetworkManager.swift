//
//  NetworkManager.swift
//  LoginNotifications
//
//  Created by Артем Гаршин on 01.11.2024.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {}
    
    func authenticateUser(login: String, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://localhost:8080/authenticate") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["login": login]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Ошибка: \(error?.localizedDescription ?? "Неизвестная ошибка")")
                return
            }
            /// Обработка ответа
            if let responseString = String(data: data, encoding: .utf8) {
                completion(responseString)
            }
        }
        task.resume()
    }
    
    func submitDecision(approved: Bool, completion: @escaping (String) -> Void) {
        guard let url = URL(string: "http://loaclhost:8080/submitDecision") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let decision = approved ? "allow" : "deny"
        request.addValue(decision, forHTTPHeaderField: "Decision")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                completion(responseString)
            } else {
                completion("Ошибка при отправке решения")
            }
        }
        task.resume()
    }

}
