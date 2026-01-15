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
    @Published var selectedImageData: Data?
    @Published var nicknameValidationState: NicknameValidationState = .empty
    
    //MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Dependencies
    
    private let useCase: AuthUseCase
    weak var coordinator: OnboardingCoordinator?
    
    private var appleIdentityToken: String
    
    //MARK: - Init
    
    init(
        useCase: AuthUseCase,
        coordinator: OnboardingCoordinator?,
        appleIdentityToken: String
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.appleIdentityToken = appleIdentityToken
        
        setupNicknameObserver()
    }
}

private extension ProfileSettingViewModel {

    //MARK: - Private Method

    func setupNicknameObserver() {
        $nickname
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.updateNicknameInputState(text)
            }
            .store(in: &cancellables)
    }
    
    func updateNicknameInputState(_ text: String) {
        if text.isEmpty {
            nicknameValidationState = .empty
            return
        }
        
        do {
           let _ = try Nickname(text)
            nicknameValidationState = .normal
        } catch let error as NicknameError {
            nicknameValidationState = .invalid(error)
        } catch {
            assertionFailure("Unhandled error: \(error)")
        }
    }
}

extension ProfileSettingViewModel {
    
    //MARK: - Method
    
    func startSignUp() {
        print("입력된 닉네임: \(nickname)")
        Task {
            do {
                try await useCase.singUp(nickname: nickname, image: selectedImageData)
                nicknameValidationState = .valid
                try await Task.sleep(nanoseconds: 1_000_000_000)
                goToOverview()
            } catch let error as NicknameError {
                if error == .duplicate {
                    nicknameValidationState = .invalid(.duplicate)
                }
            }
        }

    }
}

extension ProfileSettingViewModel {
    
    // MARK: - Coordinator

    func goToOverview() {
        coordinator?.goToOverview()
    }

    func popToPrevious() {
        coordinator?.pop()
    }
}
