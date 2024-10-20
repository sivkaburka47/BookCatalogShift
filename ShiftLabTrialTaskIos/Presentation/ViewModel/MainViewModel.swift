//
//  MainViewModel.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 19.10.2024.
//

import Foundation
import UIKit

protocol MainViewModelProtocol {
    var onBooksFetched: (([Book]) -> Void)? { get set }
    func fetchBooks()
    func showGreeting()
    func logout()
}

class MainViewModel: MainViewModelProtocol {
    
    var onBooksFetched: (([Book]) -> Void)?
    
    private var books: [Book] = []
    private let fetchBooksUseCase: FetchBooksUseCaseProtocol
    private let sessionService: SessionService
    
    init(fetchBooksUseCase: FetchBooksUseCaseProtocol, sessionService: SessionService) {
        self.fetchBooksUseCase = fetchBooksUseCase
        self.sessionService = sessionService
    }
    
    func fetchBooks() {
        fetchBooksUseCase.execute { [weak self] result in
            switch result {
            case .success(let books):
                DispatchQueue.main.async {
                    self?.books = books
                    self?.onBooksFetched?(books)
                }
            case .failure(let error):
                print("Ошибка загрузки данных: \(error.localizedDescription)")
            }
        }
    }
    
    func showGreeting() {
        let userName = UserDefaults.standard.string(forKey: "userName") ?? "Гость"
        
        let greetingVC = GreetingViewController(userName: userName)
        greetingVC.modalPresentationStyle = .overFullScreen
        greetingVC.modalTransitionStyle = .crossDissolve
        
        if let topViewController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController.present(greetingVC, animated: true, completion: nil)
        }
    }
    
    func logout() {
        sessionService.clearSession()
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
            sceneDelegate.appRouter?.start()
        }
    }
}
