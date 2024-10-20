//
//  FetchBookUseCase.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 20.10.2024.
//

import Foundation

protocol FetchBooksUseCaseProtocol {
    func execute(completion: @escaping (Result<[Book], Error>) -> Void)
}

class FetchBooksUseCase: FetchBooksUseCaseProtocol {
    private let bookRepository: BookRepositoryProtocol
    
    init(bookRepository: BookRepositoryProtocol) {
        self.bookRepository = bookRepository
    }
    
    func execute(completion: @escaping (Result<[Book], Error>) -> Void) {
        bookRepository.fetchBooks(completion: completion)
    }
}
