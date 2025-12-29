//
//  MyPageUseCase.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import UIKit

protocol MyPageUseCase {
    func getUserProfile() async throws -> MyPageUserProfileResult
    func getRegisteredTracks() async throws -> MyPageTrackResult
    func getArchiveTracks() async throws -> MyPageTrackResult
    func patchUserProfile(nickname: String?, profileImg: UIImage?) async throws
}

final class DefaultMyPageUseCase: MyPageUseCase {

    private let repository: MyPageRepository

    init(repository: MyPageRepository) {
        self.repository = repository
    }

    func getUserProfile() async throws -> MyPageUserProfileResult {
        let data = try await repository.fetchUserProfile()
        
        return data
    }
    
    func getRegisteredTracks() async throws -> MyPageTrackResult {
        let data = try await repository.fetchRegisteredTracks()
        
        return data
    }
    
    func getArchiveTracks() async throws -> MyPageTrackResult {
        let data = try await repository.fetchArchiveTracks()
        
        return data
    }
    
    func patchUserProfile(nickname: String?, profileImg: UIImage?) async throws {
        let profileImgData = profileImg?.jpegData(compressionQuality: 0.9)
        
        try await repository.updateUserProfile(nickname: nickname, profileImg: profileImgData)
    }
}
