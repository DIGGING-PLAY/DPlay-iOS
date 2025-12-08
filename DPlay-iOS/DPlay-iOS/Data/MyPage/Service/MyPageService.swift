//
//  MyPageService.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import Foundation

protocol MyPageService {
    func fetchUserProfile() async throws -> MyPageProfileResponseDTO
    func fetchRegisteredTracks() async throws -> MyPageTracksResponseDTO
    func fetchArchiveTracks() async throws -> MyPageTracksResponseDTO
}

final class MockMyPageService: MyPageService {
    func fetchUserProfile() async throws -> MyPageProfileResponseDTO {
        return MockMyPage.profileSample
    }
    
    func fetchRegisteredTracks() async throws -> MyPageTracksResponseDTO {
        return MockMyPage.registeredTracksSample
    }
    
    func fetchArchiveTracks() async throws -> MyPageTracksResponseDTO {
        return MockMyPage.archiveTracksSample
    }
}
