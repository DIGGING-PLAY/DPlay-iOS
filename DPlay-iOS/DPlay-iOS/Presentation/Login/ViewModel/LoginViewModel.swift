//
//  LoginViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/9/26.
//

import Combine

@MainActor
final class LoginViewModel: ObservableObject {
        
    //MARK: - Dependencies
    
    private let useCase: AuthUseCase
    weak var coordinator: AuthFlowCoordinator?
    
    //MARK: - Init
    
    init(useCase: AuthUseCase, coordinator: AuthFlowCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension LoginViewModel {
    
    //MARK: - Method
    
    func startLogin(appleIdentityToken: String) async {
        do {
            try await useCase.loginWithApple(appleIdentityToken: appleIdentityToken)
            coordinator?.goToMainTabBar()
        } catch {
            print("❌ login failed:", error)
        }
    }
    
}
