//
//  Book.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 19.10.2024.
//

import Foundation

struct Book: Codable {
    let id: Int
    let title: String
    let author: String
    let genre: String
    let description: String
    let isbn: String
    let image: String
    let published: String
    let publisher: String
}
