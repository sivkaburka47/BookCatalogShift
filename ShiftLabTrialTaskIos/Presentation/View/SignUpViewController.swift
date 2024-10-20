//
//  ViewController.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 18.10.2024.
//

import UIKit

class SignUpViewController: UIViewController, InputFieldViewDelegate {
    
    private var containerView: UIView!
    private var topGradientView: UIView!
    private var bottomGradientView: UIView!
    private var containerMenuView: UIView!
    
    private var viewModel: SignUpViewModel!
    
    private var signUpButton: ButtonView!
    private var nameInputField: InputFieldView!
    private var surnameInputField: InputFieldView!
    private var birthDateInputField: InputFieldView!
    private var passwordInputField: InputFieldView!
    private var confirmPasswordInputField: InputFieldView!
    
    private var appRouter: AppRouter? {
        return (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.appRouter
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        view.backgroundColor = UIColor.dark
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let sessionService = SessionService()
        viewModel = SignUpViewModel(sessionService: sessionService)
        viewModel.validationResult = { [weak self] (isValid, message) in
            guard let self = self else { return }
            if !isValid, let message = message {
                self.showAlert(with: message)
            }
        }
        
        viewModel.onRegistrationSuccess = { [weak self] in
            self?.navigateToMainViewController()
        }
        
        configureSignUpButton()
        configureContainerMenuView()
        configureImageViews()
        configureGradientViews()
        configureHeader()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
        return
    }
        
        let bottomSpace = view.frame.height - (signUpButton.frame.origin.y + signUpButton.frame.height)
        let keyboardHeight = keyboardSize.height
        
        if keyboardHeight > bottomSpace {
            let shiftDistance = keyboardHeight - bottomSpace + 20
            
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -shiftDistance
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }

    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if let topGradientLayer = topGradientView.layer.sublayers?.first as? CAGradientLayer {
            topGradientLayer.frame = topGradientView.bounds
        }
        
        if let bottomGradientLayer = bottomGradientView.layer.sublayers?.first as? CAGradientLayer {
            bottomGradientLayer.frame = bottomGradientView.bounds
        }
    }
    
    private func configureHeader() {
        let titleLabel = UILabel()
        titleLabel.text = "Регистрация"
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.boldSystemFont(ofSize: 32)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0

        view.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 76)
        ])
    }
    
    private func configureContainerMenuView() {
        containerMenuView = UIView()
        containerMenuView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerMenuView)
        NSLayoutConstraint.activate([
            containerMenuView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerMenuView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            containerMenuView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            containerMenuView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -32),
            containerMenuView.heightAnchor.constraint(equalToConstant: 272)
        ])
        
       
        
        birthDateInputField = InputFieldView(placeholder: "Дата рождения", type: .date)
        birthDateInputField.translatesAutoresizingMaskIntoConstraints = false
        containerMenuView.addSubview(birthDateInputField)
        NSLayoutConstraint.activate([
            birthDateInputField.leadingAnchor.constraint(equalTo: containerMenuView.leadingAnchor),
            birthDateInputField.trailingAnchor.constraint(equalTo: containerMenuView.trailingAnchor),
            birthDateInputField.bottomAnchor.constraint(equalTo: containerMenuView.bottomAnchor),
            birthDateInputField.heightAnchor.constraint(equalToConstant: 48)
        ])
        birthDateInputField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        confirmPasswordInputField = InputFieldView(placeholder: "Подтвердите пароль", type: .password)
        confirmPasswordInputField.translatesAutoresizingMaskIntoConstraints = false
        containerMenuView.addSubview(confirmPasswordInputField)
        NSLayoutConstraint.activate([
            confirmPasswordInputField.leadingAnchor.constraint(equalTo: containerMenuView.leadingAnchor),
            confirmPasswordInputField.trailingAnchor.constraint(equalTo: containerMenuView.trailingAnchor),
            confirmPasswordInputField.bottomAnchor.constraint(equalTo: birthDateInputField.topAnchor, constant: -8),
            confirmPasswordInputField.heightAnchor.constraint(equalToConstant: 48)
        ])
        confirmPasswordInputField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        passwordInputField = InputFieldView(placeholder: "Пароль", type: .password)
        passwordInputField.translatesAutoresizingMaskIntoConstraints = false
        containerMenuView.addSubview(passwordInputField)
        NSLayoutConstraint.activate([
            passwordInputField.leadingAnchor.constraint(equalTo: containerMenuView.leadingAnchor),
            passwordInputField.trailingAnchor.constraint(equalTo: containerMenuView.trailingAnchor),
            passwordInputField.bottomAnchor.constraint(equalTo: confirmPasswordInputField.topAnchor, constant: -8),
            passwordInputField.heightAnchor.constraint(equalToConstant: 48)
        ])
        passwordInputField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        surnameInputField = InputFieldView(placeholder: "Фамилия", type: .text)
        surnameInputField.translatesAutoresizingMaskIntoConstraints = false
        containerMenuView.addSubview(surnameInputField)
        NSLayoutConstraint.activate([
            surnameInputField.leadingAnchor.constraint(equalTo: containerMenuView.leadingAnchor),
            surnameInputField.trailingAnchor.constraint(equalTo: containerMenuView.trailingAnchor),
            surnameInputField.bottomAnchor.constraint(equalTo: passwordInputField.topAnchor, constant: -8),
            surnameInputField.heightAnchor.constraint(equalToConstant: 48)
        ])
        surnameInputField.delegate = self
        surnameInputField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
        
        
        nameInputField = InputFieldView(placeholder: "Имя", type: .text)
        nameInputField.translatesAutoresizingMaskIntoConstraints = false
        containerMenuView.addSubview(nameInputField)
        NSLayoutConstraint.activate([
            nameInputField.leadingAnchor.constraint(equalTo: containerMenuView.leadingAnchor),
            nameInputField.trailingAnchor.constraint(equalTo: containerMenuView.trailingAnchor),
            nameInputField.bottomAnchor.constraint(equalTo: surnameInputField.topAnchor, constant: -8),
            nameInputField.heightAnchor.constraint(equalToConstant: 48)
        ])
        nameInputField.delegate = self
        nameInputField.textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingDidEnd)
    }
    
    private func configureSignUpButton() {
        signUpButton = ButtonView(title: "Зарегистрироваться", color: .hint)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(signUpButton)
        NSLayoutConstraint.activate([
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            signUpButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24)
        ])
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    private func configureGradientViews() {
        topGradientView = UIView()
        topGradientView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(topGradientView)

        let topGradientLayer = CAGradientLayer()
        topGradientLayer.colors = [
            UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 1.0).cgColor,
            UIColor(red: 30/255, green: 30/255, blue: 30/255, alpha: 0.0).cgColor
        ]
        topGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        topGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        topGradientLayer.frame = topGradientView.bounds
        topGradientView.layer.addSublayer(topGradientLayer)

        NSLayoutConstraint.activate([
            topGradientView.topAnchor.constraint(equalTo: containerView.topAnchor),
            topGradientView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            topGradientView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            topGradientView.heightAnchor.constraint(equalToConstant: 314)
        ])

        bottomGradientView = UIView()
        bottomGradientView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(bottomGradientView)

        let bottomGradientLayer = CAGradientLayer()
        bottomGradientLayer.colors = [
            UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 0.0).cgColor,
            UIColor(red: 26/255, green: 26/255, blue: 26/255, alpha: 1.0).cgColor
        ]
        bottomGradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        bottomGradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        bottomGradientLayer.frame = bottomGradientView.bounds
        bottomGradientView.layer.addSublayer(bottomGradientLayer)

        NSLayoutConstraint.activate([
            bottomGradientView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            bottomGradientView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bottomGradientView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bottomGradientView.heightAnchor.constraint(equalToConstant: 314)
        ])
    }

    private func configureImageViews() {
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 24
        containerView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        view.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: view.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: containerMenuView.topAnchor, constant: -32)
        ])

        var imageViews: [UIImageView] = []

        for i in 0..<6 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.image = UIImage(named: "imgContainer_\(i + 1)")
            imageViews.append(imageView)
            containerView.addSubview(imageView)
        }

        for (index, imageView) in imageViews.enumerated() {
            NSLayoutConstraint.activate([
                imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
                imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            ])

            if index == 0 {
                imageView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            } else {
                imageView.topAnchor.constraint(equalTo: imageViews[index - 1].bottomAnchor, constant: 8).isActive = true
            }
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func updateSignUpButtonState() {
        let name = nameInputField.textField.text ?? ""
        let surname = surnameInputField.textField.text ?? ""
        let password = passwordInputField.textField.text ?? ""
        let confirmPassword = confirmPasswordInputField.textField.text ?? ""
        let birthDate = birthDateInputField.textField.text ?? ""

        let allFieldsFilled = !name.isEmpty && !surname.isEmpty && !password.isEmpty && !confirmPassword.isEmpty && !birthDate.isEmpty

        if allFieldsFilled {
            signUpButton.changeButtonType(to: .orange)
        } else {
            signUpButton.changeButtonType(to: .hint)

        }
    }

    @objc private func textFieldDidChange(_ textField: UITextField) {
        updateSignUpButtonState()
    }
    
    func inputFieldDidClearText(_ inputField: InputFieldView) {
        updateSignUpButtonState()
    }
    
    @objc private func signUpButtonTapped() {
        let name = nameInputField.textField.text
        let surname = surnameInputField.textField.text
        let password = passwordInputField.textField.text
        let confirmPassword = confirmPasswordInputField.textField.text
        let birthDate = birthDateInputField.textField.text
        
        viewModel.validate(name: name, surname: surname, password: password, confirmPassword: confirmPassword, birthDate: birthDate)
    }
    
    private func showAlert(with message: String) {
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func navigateToMainViewController() {
        appRouter?.navigateToMain()
    }

}
