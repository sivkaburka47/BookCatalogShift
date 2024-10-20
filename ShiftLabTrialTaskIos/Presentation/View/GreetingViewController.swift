//
//  GreetingViewController.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 19.10.2024.
//

import UIKit

class GreetingViewController: UIViewController {
    
    private let greetingLabel = UILabel()
    private let closeButton = UIButton(type: .system)
    
    private var userName: String = "Гость"
    
    init(userName: String) {
        self.userName = userName
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        
        let containerView = UIView()
        containerView.backgroundColor = UIColor.dark
        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 150),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
        ])
        
        
        
        greetingLabel.text = "Рады видеть тебя снова, \(userName)!"
        greetingLabel.textAlignment = .center
        greetingLabel.font = UIFont.boldSystemFont(ofSize: 20)
        greetingLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(greetingLabel)
        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            greetingLabel.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
        ])
        
        
        
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: greetingLabel.bottomAnchor, constant: 20),
            closeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
    }
    
    @objc private func didTapCloseButton() {
        dismiss(animated: true, completion: nil)
    }
}
