//
//  MusicDetailRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/18/25.
//

import Foundation

protocol MusicDetailRepository {
    func fetchMusicDetail(trackId: String) async throws -> MusicDetail
}

final class DefaultMusicDetailRepository: MusicDetailRepository {

    private let service: MusicDetailService

    init(service: MusicDetailService) {
        self.service = service
    }

    func fetchMusicDetail(trackId: String) async throws -> MusicDetail {
        let dto = try await service.fetchMusicDetail(trackId: trackId)
        return dto.toEntity()   
    }
}
