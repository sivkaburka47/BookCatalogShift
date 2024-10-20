//
//  MainViewController.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 19.10.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private let tableView = UITableView()
    private var greetButton: ButtonView!
    
    private var viewModel: MainViewModelProtocol?
    
    private var books: [Book] = []
    private var expandedIndexPaths: Set<IndexPath> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        
        configureView()
        
        let networkService = NetworkService()
        let bookRepository = BookRepository(networkService: networkService)
        let fetchBooksUseCase = FetchBooksUseCase(bookRepository: bookRepository)
        let sessionService = SessionService()
        
        viewModel = MainViewModel(fetchBooksUseCase: fetchBooksUseCase, sessionService: sessionService)
        
        bindViewModel()
        
        viewModel?.fetchBooks()
    }

    private func configureView() {
        view.backgroundColor = UIColor.dark
        title = "Доступные книги"
        
        let logoutButton = UIBarButtonItem(title: "Выход", style: .plain, target: self, action: #selector(didTapLogoutButton))
        self.navigationItem.rightBarButtonItem = logoutButton
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BookTableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 160
        view.addSubview(tableView)
        
        greetButton = ButtonView(title: "Приветствие", color: .orange)
        greetButton.addTarget(self, action: #selector(didTapGreetButton), for: .touchUpInside)
        view.addSubview(greetButton)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        greetButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: greetButton.topAnchor, constant: -20),
            
            greetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            greetButton.heightAnchor.constraint(equalToConstant: 48),
            greetButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            greetButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
    }


    private func bindViewModel() {
        viewModel?.onBooksFetched = { [weak self] books in
            self?.books = books
            self?.tableView.reloadData()
        }
    }

    @objc private func didTapGreetButton() {
        viewModel?.showGreeting()
    }
    
    @objc private func didTapLogoutButton() {
        viewModel?.logout()
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as? BookTableViewCell else {
            return UITableViewCell()
        }
        
        let book = books[indexPath.row]
        let isExpanded = expandedIndexPaths.contains(indexPath)
        cell.configure(with: book, expanded: isExpanded)
        
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if expandedIndexPaths.contains(indexPath) {
            expandedIndexPaths.remove(indexPath)
        } else {
            expandedIndexPaths.insert(indexPath)
        }
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return expandedIndexPaths.contains(indexPath) ? 320 : 160
    }
}
