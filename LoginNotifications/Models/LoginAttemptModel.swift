//
//  LoginAttemptModel.swift
//  LoginNotifications
//
//  Created by Артем Гаршин on 01.11.2024.
//

import Foundation
import Foundation

/// Модель для информации о попытке входа
struct LoginAttemptModel: Codable {
    let login: String
    let browser: String
    let operatingSystem: String
    let ipAddress: String
}
