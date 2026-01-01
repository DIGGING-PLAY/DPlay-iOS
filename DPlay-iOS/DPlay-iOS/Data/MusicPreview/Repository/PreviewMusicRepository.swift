//
//  PreviewMusicRepository.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation

protocol PreviewMusicRepository {
    func requestPreview(
        trackId: String,
        storefront: String?
    ) async throws -> PreviewMusic
}

final class DefaultPreviewMusicRepository: PreviewMusicRepository {

    private let service: PreviewNetworkService

    init(service: PreviewNetworkService) {
        self.service = service
    }

    func requestPreview(
        trackId: String,
        storefront: String?
    ) async throws -> PreviewMusic {

        let responseDTO = try await service.requestPreview(
            trackId: trackId,
            storefront: storefront
        )

        return responseDTO.data.toEntity()
    }
}
