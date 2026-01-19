//
//  TermsViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/15/25.
//

final class TermsViewModel {
    
    //MARK: - Properties
    
    var serviceAgreed = false
    var privacyAgreed = false
    
    var allAgreed: Bool {
        serviceAgreed && privacyAgreed
    }
    
    weak var coordinator: OnboardingCoordinator?
    
    init(coordinator: OnboardingCoordinator?) {
        self.coordinator = coordinator
    }
}

extension TermsViewModel {
    
    //MARK: - Method

    // 전체 동의 토글
    func toggleAll() {
        let newValue = !allAgreed
        serviceAgreed = newValue
        privacyAgreed = newValue
    }

    // 서비스 약관 토글
    func toggleService() {
        serviceAgreed.toggle()
    }

    // 개인정보 약관 토글
    func togglePrivacy() {
        privacyAgreed.toggle()
    }
}

extension TermsViewModel {
    
    // MARK: - Coordinator

    func goToProfileSetting() {
        coordinator?.goToProfileSetting()
    }
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
