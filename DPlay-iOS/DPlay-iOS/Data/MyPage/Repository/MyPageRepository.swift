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
    func fetchArchiveTracks(userId: Int, cursor: String?) async throws -> MyPageTrackResult
    func updateUserProfile(nickname: String?, profileImg: Data?) async throws
}

final class DefaultMyPageRepository: MyPageRepository {

    private let service: MyPageService

    init(service: MyPageService) {
        self.service = service
    }

    func fetchUserProfile(userId: Int) async throws -> MyPageUserProfileResult {
        let response = try await service.fetchUserProfile(userId: userId)

        guard let data = response.data else {
            throw AppError.emptyData
        }

        let userProfile = data.toEntity()
        let result = MyPageUserProfileResult(
            profile: userProfile,
            isHost: data.isHost,
            pushOn: data.pushOn
        )

        return result
    }

    func fetchRegisteredTracks(userId: Int, cursor: String?) async throws -> MyPageTrackResult {
        let response = try await service.fetchRegisteredTracks(userId: userId, cursor: cursor)

        guard let data = response.data else {
            throw AppError.emptyData
        }

        let musics = data.toEntity()
        let result = MyPageTrackResult(
            musics: musics,
            visibleLimit: data.visibleLimit,
            nextCursor: data.nextCursor,
            isHost: data.isHost
        )

        return result
    }

    func fetchArchiveTracks(userId: Int, cursor: String?) async throws -> MyPageTrackResult {
        let response = try await service.fetchArchiveTracks(userId: userId, cursor: cursor)

        guard let data = response.data else {
            throw AppError.emptyData
        }

        let musics = data.toEntity()
        let result = MyPageTrackResult(
            musics: musics,
            visibleLimit: data.visibleLimit,
            nextCursor: data.nextCursor,
            isHost: data.isHost
        )

        return result
    }
    
    func updateUserProfile(nickname: String?, profileImg: Data?) async throws {
        let requestBody = UpdateProfileRequestDTO(nickname: nickname)
        try await service.updateUserProfile(changeProfileRequest: requestBody, profileImg: profileImg)
    }
}
