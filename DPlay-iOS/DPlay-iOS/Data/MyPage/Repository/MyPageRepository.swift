//
//  MyPageRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import Foundation

protocol MyPageRepository {
    func fetchUserProfile() async throws -> MyPageUserProfileResult
    func fetchRegisteredTracks() async throws -> MyPageTrackResult
    func fetchArchiveTracks() async throws -> MyPageTrackResult
    func updateUserProfile(nickname: String?, profileImg: Data?) async throws
}

final class DefaultMyPageRepository: MyPageRepository {

    private let service: MyPageService

    init(service: MyPageService) {
        self.service = service
    }

    func fetchUserProfile() async throws -> MyPageUserProfileResult {
        let response = try await service.fetchUserProfile()
        
        let userProfile = response.data.toEntity()
        let result = MyPageUserProfileResult(
            profile: userProfile,
            isHost: response.data.isHost,
            pushOn: response.data.pushOn
        )
        
        return result
    }

    func fetchRegisteredTracks() async throws -> MyPageTrackResult {
        let response = try await service.fetchRegisteredTracks()
        
        let musics = response.data.toEntity()
        let result = MyPageTrackResult(
            musics: musics,
            visibleLimit: response.data.visibleLimit,
            nextCursor: response.data.nextCursor,
            isHost: response.data.isHost
        )

        return result
    }

    func fetchArchiveTracks() async throws -> MyPageTrackResult {
        let response = try await service.fetchArchiveTracks()

        let musics = response.data.toEntity()
        let result = MyPageTrackResult(
            musics: musics,
            visibleLimit: response.data.visibleLimit,
            nextCursor: response.data.nextCursor,
            isHost: response.data.isHost
        )

        return result
    }
    
    func updateUserProfile(nickname: String? = nil, profileImg: Data? = nil) async throws { }
}
