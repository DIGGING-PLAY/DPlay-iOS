//
//  OnboardingRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import Foundation

protocol OnboardingRepository {
    func validateNicknameDuplicate(nickname: String) async throws -> Bool
    func singUp(nickname: String, image: Data) async throws
}

final class DefaultOnboardingRepository: OnboardingRepository {
    func validateNicknameDuplicate(nickname: String) async throws -> Bool {
        return true
    }
        
    func singUp(nickname: String, image: Data) async throws {
        print("회원가입 요청")
    }
}
