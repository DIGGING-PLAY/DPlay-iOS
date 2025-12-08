//
//  MyPageUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import Foundation

protocol MyPageUseCase {
    func getUserProfile() async throws -> UserProfile
    func getRegisteredTracks() async throws -> MyPageMusics
    func getArchiveTracks() async throws -> MyPageMusics
}

final class DefaultMyPageUseCase: MyPageUseCase {

    private let repository: MyPageRepository

    init(repository: MyPageRepository) {
        self.repository = repository
    }

    func getUserProfile() async throws -> UserProfile {
        let data = try await repository.fetchUserProfile()
        
        return data
    }
    
    func getRegisteredTracks() async throws -> MyPageMusics {
        let data = try await repository.fetchRegisteredTracks()
        
        return data
    }
    
    func getArchiveTracks() async throws -> MyPageMusics {
        let data = try await repository.fetchArchiveTracks()
        
        return data
    }
}
