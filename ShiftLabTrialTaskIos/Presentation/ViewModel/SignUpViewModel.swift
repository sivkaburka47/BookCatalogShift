//
//  SignUpViewModel.swift
//  ShiftLabTrialTaskIos
//
//  Created by Станислав Дейнекин on 18.10.2024.
//

import Foundation

class SignUpViewModel {
    
    var validationResult: ((Bool, String?) -> Void)?
    var onRegistrationSuccess: (() -> Void)?
    
    private let sessionService: SessionServiceProtocol
    
    init(sessionService: SessionServiceProtocol) {
        self.sessionService = sessionService
    }
    
    func validate(name: String?, surname: String?, password: String?, confirmPassword: String?, birthDate: String?) {
        guard let name = name, !name.isEmpty else {
            validationResult?(false, "Имя не может быть пустым")
            return
        }
        guard name.count >= 2 else {
            validationResult?(false, "Имя должно содержать не менее 2 букв")
            return
        }
        guard name.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil else {
            validationResult?(false, "Имя должно содержать только буквы")
            return
        }
        
        guard let surname = surname, !surname.isEmpty else {
            validationResult?(false, "Фамилия не может быть пустой")
            return
        }
        guard surname.count >= 2 else {
            validationResult?(false, "Фамилия должна содержать не менее 2 букв")
            return
        }
        guard surname.rangeOfCharacter(from: CharacterSet.letters.inverted) == nil else {
            validationResult?(false, "Фамилия должна содержать только буквы")
            return
        }
        
        guard let password = password, !password.isEmpty else {
            validationResult?(false, "Пароль не может быть пустым")
            return
        }
        guard password.count >= 8 else {
            validationResult?(false, "Пароль должен содержать не менее 8 символов")
            return
        }
        guard password.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) == nil else {
            validationResult?(false, "Пароль должен содержать только буквы английского алфавита и цифры")
            return
        }
        guard password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil else {
            validationResult?(false, "Пароль должен содержать хотя бы одну букву в верхнем регистре")
            return
        }
        let digitCharacters = password.filter { $0.isNumber }
        guard digitCharacters.count >= 3 else {
            validationResult?(false, "Пароль должен содержать минимум 3 цифры")
            return
        }
        
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            validationResult?(false, "Подтверждение пароля не может быть пустым")
            return
        }
        
        guard password == confirmPassword else {
            validationResult?(false, "Пароли не совпадают")
            return
        }
        
        guard let birthDate = birthDate, !birthDate.isEmpty else {
            validationResult?(false, "Дата рождения не может быть пустой")
            return
        }
        
        let iso8601Date = formatDateToISO8601(birthDate)
        guard let iso8601Date = iso8601Date else {
            validationResult?(false, "Неверный формат даты рождения")
            return
        }
        
        validationResult?(true, nil)
        registerUser(name: name)
    }
    
    private func registerUser(name: String) {
        sessionService.saveUserName(name)
        onRegistrationSuccess?()
    }
    
    private func formatDateToISO8601(_ dateString: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy г."
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        
        let iso8601Formatter = ISO8601DateFormatter()
        iso8601Formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        return iso8601Formatter.string(from: date)
    }
}
