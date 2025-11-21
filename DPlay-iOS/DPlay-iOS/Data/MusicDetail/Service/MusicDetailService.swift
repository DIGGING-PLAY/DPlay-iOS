//
//  MusicDetailService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

protocol MusicDetailService {
    func fetchMusicDetail(trackId: String) async throws -> MusicDetailDataDTO
}

final class MockMusicDetailService: MusicDetailService {
    func fetchMusicDetail(trackId: String) async throws -> MusicDetailDataDTO {
        return MockMusicDetail.sample
    }
}
