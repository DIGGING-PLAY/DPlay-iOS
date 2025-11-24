//
//  ProfileSettingViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import Foundation
import Combine

final class ProfileSettingViewModel: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var nickname: String = ""
    
    //MARK: - Properties
    
    var onValidationStateChanged: ((NicknameValidationState) -> Void)?
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Dependencies
    
    private let useCase: AuthUseCase
    weak var coordinator: OnboardingCoordinator?
    
    //MARK: - Init
    
    init(useCase: AuthUseCase, coordinator: OnboardingCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
        
        setupNicknameObserver()
    }
}

private extension ProfileSettingViewModel {

    //MARK: - Private Method

    func setupNicknameObserver() {
        $nickname
            .removeDuplicates()
            .sink { [weak self] text in
                self?.updateNicknameInputState(text)
            }
            .store(in: &cancellables)
    }
    
    func updateNicknameInputState(_ text: String) {
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
}

extension ProfileSettingViewModel {
    
    //MARK: - Method
    
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
