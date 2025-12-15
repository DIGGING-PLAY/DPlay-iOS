//
//  ProfileEditViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import Foundation
import Combine

final class ProfileEditViewModel: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var nickname: String = ""
    @Published var selectedImageData: Data?
    @Published var nicknameValidationState: NicknameValidationState = .empty
    
    //MARK: - Properties
    
    private var cancellables = Set<AnyCancellable>()
    
    //MARK: - Dependencies
    
    private let useCase: MyPageUseCase
    weak var coordinator: MyPageCoordinator?
    
    //MARK: - Init
    
    init(useCase: MyPageUseCase, coordinator: MyPageCoordinator?) {
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
        print("입력된 닉네임: \(nickname)")
        Task {
            do {
//                try await useCase.editProfile(nickname: nickname, image: selectedImageData)
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
