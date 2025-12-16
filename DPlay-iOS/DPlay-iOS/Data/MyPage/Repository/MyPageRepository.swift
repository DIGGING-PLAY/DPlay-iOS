//
//  MyPageRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import Foundation

protocol MyPageRepository {
    func fetchUserProfile() async throws -> UserProfile
    func fetchRegisteredTracks() async throws -> MyPageMusics
    func fetchArchiveTracks() async throws -> MyPageMusics
    func updateUserProfile(nickname: String?, profileImg: Data?) async throws
}

final class DefaultMyPageRepository: MyPageRepository {

    private let service: MyPageService

    init(service: MyPageService) {
        self.service = service
    }

    func fetchUserProfile() async throws -> UserProfile {
        let response = try await service.fetchUserProfile()
        let entity = response.data.toEntity()

        return entity
    }

    func fetchRegisteredTracks() async throws -> MyPageMusics {
        let response = try await service.fetchRegisteredTracks()
        let entity = response.data.toEntity()

        return entity
    }

    func fetchArchiveTracks() async throws -> MyPageMusics {
        let response = try await service.fetchArchiveTracks()
        let entity = response.data.toEntity()

        return entity
    }
    
    func updateUserProfile(nickname: String? = nil, profileImg: Data? = nil) async throws { }
}
