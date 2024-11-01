//
//  DecisionModel.swift
//  LoginNotifications
//
//  Created by Артем Гаршин on 01.11.2024.
//

import Foundation

import Foundation

/// Модель для отправки решения (разрешить/отклонить)
struct DecisionModel: Codable {
    let login: String
    let decision: String
}

