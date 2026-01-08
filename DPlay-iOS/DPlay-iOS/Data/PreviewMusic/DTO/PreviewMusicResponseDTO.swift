//
//  MusicResponseDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation


typealias PreviewMusicResponseDTO = BaseResponseDTO<PreviewTrackDataDTO>

struct PreviewTrackDataDTO: Decodable {
    let sessionId: String
    let trackId: String
    let streamUrl: String
    let expiresAt: String?
}

// MARK: - DTO to Entity

extension PreviewTrackDataDTO {
    func toEntity() -> PreviewMusic {
        PreviewMusic(
            sessionId: sessionId,
            trackId: trackId,
            streamURL: URL(string: streamUrl)!,
            expiresAt: expiresAt.flatMap {
                ISO8601DateFormatter().date(from: $0)
            }
        )
    }
}
