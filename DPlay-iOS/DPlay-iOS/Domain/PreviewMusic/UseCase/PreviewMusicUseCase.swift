//
//  PreviewMusicUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation

final class PreviewMusicUseCase {

    private let repository: PreviewMusicRepository

    init(repository: PreviewMusicRepository) {
        self.repository = repository
    }

    func execute(
        trackId: String,
        storefront: String?
    ) async throws -> PreviewMusic {
        try Task.checkCancellation()
        return try await repository.requestPreview(
            trackId: trackId,
            storefront: storefront
        )
    }
}
