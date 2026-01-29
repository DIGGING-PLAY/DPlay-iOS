//
//  MyPageRepository.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import Foundation

protocol MyPageRepository {
    func fetchUserProfile(userId: Int) async throws -> MyPageUserProfileResult
    func fetchRegisteredTracks(userId: Int, cursor: String?) async throws -> MyPageTrackResult
    func fetchArchiveTracks(userId: Int) async throws -> MyPageTrackResult
    func updateUserProfile(nickname: String?, profileImg: Data?) async throws
}

final class DefaultMyPageRepository: MyPageRepository {

    private let service: MyPageService

    init(service: MyPageService) {
        self.service = service
    }

    func fetchUserProfile(userId: Int) async throws -> MyPageUserProfileResult {
        let response = try await service.fetchUserProfile(userId: userId)
        
        let userProfile = response.data.toEntity()
        let result = MyPageUserProfileResult(
            profile: userProfile,
            isHost: response.data.isHost,
            pushOn: response.data.pushOn
        )
        
        return result
    }

    func fetchRegisteredTracks(userId: Int, cursor: String?) async throws -> MyPageTrackResult {
        let response = try await service.fetchRegisteredTracks(userId: userId, cursor: cursor)
        
        let musics = response.data.toEntity()
        let result = MyPageTrackResult(
            musics: musics,
            visibleLimit: response.data.visibleLimit,
            nextCursor: response.data.nextCursor,
            isHost: response.data.isHost
        )

        return result
    }

    func fetchArchiveTracks(userId: Int) async throws -> MyPageTrackResult {
        let response = try await service.fetchArchiveTracks(userId: userId)

        let musics = response.data.toEntity()
        let result = MyPageTrackResult(
            musics: musics,
            visibleLimit: response.data.visibleLimit,
            nextCursor: response.data.nextCursor,
            isHost: response.data.isHost
        )

        return result
    }
    
    func updateUserProfile(nickname: String?, profileImg: Data?) async throws {
        let requestBody = UpdateProfileRequestDTO(nickname: nickname)
        try await service.updateUserProfile(changeProfileRequest: requestBody, profileImg: profileImg)
    }
}
