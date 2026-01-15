//
//  MusicSearchRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

protocol MusicSearchRepository {
    func searchTracks(
        keyword: String,
        cursor: String?
    ) async throws -> MusicSearchResult
    
    func fetchTrackDetail(trackId: String) async throws -> MusicTrack
}

final class DefaultMusicSearchRepository: MusicSearchRepository {

    private let service: MusicSearchService

    init(service: MusicSearchService) {
        self.service = service
    }

    func searchTracks(
        keyword: String,
        cursor: String?
    ) async throws -> MusicSearchResult {

        let dto = try await service.searchTracks(
            keyword: keyword,
            cursor: cursor
        )

        let tracks = dto.data?.items.map { $0.toEntity() } ?? []

        return MusicSearchResult(
            tracks: tracks,
            nextCursor: dto.data?.nextCursor
        )
    }
    
    func fetchTrackDetail(trackId: String) async throws -> MusicTrack {
        let dto = try await service.fetchTrackDetail(trackId: trackId)

        guard let data = dto.data else {
            throw AppError.emptyData
        }

        return data.toEntity()
    }
}
