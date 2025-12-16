//
//  ProfileEditViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import UIKit
import Combine

final class ProfileEditViewModel: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var nickname: String?
    @Published var profileImg: UIImage?
    @Published var nicknameValidationState: NicknameValidationState = .empty
    
    //MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Dependencies
    
    private let useCase: MyPageUseCase
    weak var coordinator: MyPageCoordinator?
    
    //MARK: - Init
    
    init(
        nickname: String,
        profileImg: UIImage?,
        useCase: MyPageUseCase,
        coordinator: MyPageCoordinator?
    ) {
        self.nickname = nickname
        self.profileImg = profileImg
        self.useCase = useCase
        self.coordinator = coordinator
        
        setupNicknameObserver()
    }
}

private extension ProfileEditViewModel {

    //MARK: - Private Method

    func setupNicknameObserver() {
        $nickname
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                guard let text else { return }
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

extension ProfileEditViewModel {
    
    //MARK: - Method
    
    func startEdittingProfile() {
        Task {
            do {
                try await useCase.patchUserProfile(nickname: nickname, profileImg: profileImg)
                nicknameValidationState = .valid
                try await Task.sleep(nanoseconds: 1_000_000_000)
                popToPrevious()
            } catch let error as NicknameError {
                if error == .duplicate {
                    nicknameValidationState = .invalid(.duplicate)
                }
            }
        }

    }
}

extension ProfileEditViewModel {
    
    // MARK: - Coordinator
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
