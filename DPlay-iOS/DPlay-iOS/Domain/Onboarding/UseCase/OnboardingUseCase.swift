//
//  OnboardingUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import Foundation

protocol OnboardingUseCase {
    func validateNicknameDuplicate(nickname: Nickname) async throws -> Bool
    func singUp(profile: Profile) async throws
}

final class DefaultOnboardingUseCase: OnboardingUseCase {
    
    private let onboardingRepository: OnboardingRepository
    
    init(onboardingRepository: OnboardingRepository) {
        self.onboardingRepository = onboardingRepository
    }
    
    //1. 닉네임 중복 검사
    func validateNicknameDuplicate(nickname: Nickname) async throws -> Bool {
        return try await onboardingRepository.validateNicknameDuplicate(nickname: nickname.value)
    }
    
    //2. 회원가입
    func singUp(profile: Profile) async throws {
        try await onboardingRepository.singUp(nickname: profile.nickname.value, image: profile.profileImage)
    }
}
