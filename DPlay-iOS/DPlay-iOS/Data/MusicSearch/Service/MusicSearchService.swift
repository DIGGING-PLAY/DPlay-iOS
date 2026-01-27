//
//  MusicSearchService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/11/26.
//

import Foundation

protocol MusicSearchService {
    func searchTracks(
        keyword: String,
        cursor: String?
    ) async throws -> MusicSearchResponseDTO
}

final class MusicSearchNetworkService: MusicSearchService {

    private let apiService: BaseAPIService

    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }

    func searchTracks(
        keyword: String,
        cursor: String?
    ) async throws -> MusicSearchResponseDTO {

        let result = await apiService.request(
            MusicSearchAPI.searchTracks(
                query: keyword,
                limit: 20,
                storefront: "kr",
                cursor: cursor
            ),
            MusicSearchResponseDTO.self
        )

        switch result {
        case .success(let dto):
            guard let dto else { throw AppError.emptyData }
            return dto
        default:
            throw AppError.serverError
        }
    }
}
