//
//  MusicSearchUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

protocol MusicSearchUseCase {
    
    /// 음악 검색 (커서 기반)
    func searchTracks(
        keyword: String,
        cursor: String?
    ) async throws -> MusicSearchResult
}

//  DefaultMusicSearchUseCase.swift

import Foundation

final class DefaultMusicSearchUseCase: MusicSearchUseCase {

    private let repository: MusicSearchRepository

    init(repository: MusicSearchRepository) {
        self.repository = repository
    }

    // MARK: - Search

    func searchTracks(
        keyword: String,
        cursor: String?
    ) async throws -> MusicSearchResult {
        try Task.checkCancellation()
        return try await repository.searchTracks(
            keyword: keyword,
            cursor: cursor
        )
    }
}
