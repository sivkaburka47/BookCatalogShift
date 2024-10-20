//
//  BookResponse.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 20.10.2024.
//

import Foundation

struct BookResponse: Codable {
    let status: String
    let code: Int
    let locale: String
    let total: Int
    let data: [Book]
}
