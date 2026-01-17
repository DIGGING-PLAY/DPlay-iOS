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
        
        guard let data = dto.data else {
            throw AppError.serverError
        }
        
        var tracks: [MusicTrack] = []
        for item in data.items {
            tracks.append(try item.toEntity())
        }
        
        return MusicSearchResult(
            tracks: tracks,
            nextCursor: data.nextCursor
        )
    }
}
