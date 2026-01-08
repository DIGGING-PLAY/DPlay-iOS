//
//  MockPreviewNetworkService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation

final class MockPreviewNetworkService: PreviewNetworkService {

    func requestPreview(
        trackId: String,
        storefront: String?
    ) async throws -> PreviewMusicResponseDTO {

        return MockPreviewMusic.sample
    }
}
