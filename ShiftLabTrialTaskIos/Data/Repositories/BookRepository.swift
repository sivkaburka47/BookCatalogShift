//
//  BookRepository.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 20.10.2024.
//

import Foundation

protocol BookRepositoryProtocol {
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void)
}

class BookRepository: BookRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchBooks(completion: @escaping (Result<[Book], Error>) -> Void) {
        networkService.request(endpoint: BookEndpoints.fetchBooks) { (result: Result<BookResponse, Error>) in
            switch result {
            case .success(let bookResponse):
                completion(.success(bookResponse.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
