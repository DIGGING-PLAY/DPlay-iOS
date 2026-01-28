//
//  MyPageUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import UIKit

protocol MyPageUseCase {
    func getUserProfile(userId: Int) async throws -> MyPageUserProfileResult
    func getRegisteredTracks(userId: Int) async throws -> MyPageTrackResult
    func getArchiveTracks(userId: Int) async throws -> MyPageTrackResult
    func patchUserProfile(nickname: String?, profileImg: UIImage?) async throws
}

final class DefaultMyPageUseCase: MyPageUseCase {

    private let repository: MyPageRepository

    init(repository: MyPageRepository) {
        self.repository = repository
    }

    func getUserProfile(userId: Int) async throws -> MyPageUserProfileResult {
        let data = try await repository.fetchUserProfile(userId: userId)
        
        return data
    }
    
    func getRegisteredTracks(userId: Int) async throws -> MyPageTrackResult {
        let data = try await repository.fetchRegisteredTracks(userId: userId)
        
        return data
    }
    
    func getArchiveTracks(userId: Int) async throws -> MyPageTrackResult {
        let data = try await repository.fetchArchiveTracks(userId: userId)
        
        return data
    }
    
    func patchUserProfile(nickname: String?, profileImg: UIImage?) async throws {
        let profileImgData = profileImg?.jpegData(compressionQuality: 0.9)
        
        try await repository.updateUserProfile(nickname: nickname, profileImg: profileImgData)
    }
}
