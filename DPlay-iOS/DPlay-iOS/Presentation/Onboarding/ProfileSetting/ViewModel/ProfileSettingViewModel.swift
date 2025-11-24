//
//  ProfileSettingViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import Foundation

final class ProfileSettingViewModel {
    
    //MARK: - Properties
    
    private(set) var currentText: String = ""
    var onValidationStateChanged: ((NicknameValidationState) -> Void)?
    
    private let useCase: AuthUseCase
    weak var coordinator: OnboardingCoordinator?
    
    init(useCase: AuthUseCase, coordinator: OnboardingCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension ProfileSettingViewModel {
    
    //MARK: - Method
    
    func updateNicknameInputState(_ text: String) {
        currentText = text
        
        guard !text.isEmpty else {
            onValidationStateChanged?(.empty)
            return
        }
        
        do {
           let _ = try Nickname(text)
            onValidationStateChanged?(.normal)
        } catch let error as NicknameError {
            onValidationStateChanged?(.invalid(error))
        } catch {
            assertionFailure("Unhandled error: \(error)")
        }
    }
    
    func startSignUp(nickname: String, image: Data? = nil) {
        Task {
            do {
                try await useCase.singUp(nickname: nickname, image: image)
                
                onValidationStateChanged?(.valid)
            } catch let error as NicknameError {
                if error == .duplicate {
                    onValidationStateChanged?(.invalid(.duplicate))
                }
            }
        }

    }
}

extension ProfileSettingViewModel {
    
    // MARK: - Coordinator

    func popToPrevious() {
        coordinator?.pop()
    }
}
