//
//  BookEndPoints.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 20.10.2024.
//

import Foundation

protocol Endpoint {
    var url: String { get }
}

enum BookEndpoints: Endpoint {
    case fetchBooks
    
    var url: String {
        switch self {
        case .fetchBooks:
            return "https://fakerapi.it/api/v1/books"
        }
    }
}
