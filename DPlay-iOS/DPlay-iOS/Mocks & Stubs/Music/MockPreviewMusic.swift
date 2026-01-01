//
//  MockPreviewMusic.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation

// MARK: - Mock Preview Response

enum MockPreviewMusic {
    static let sample = MusicResponseDTO(
        status: true,
        code: 2000,
        message: "요청이 성공했습니다.",
        data: PreviewTrackDataDTO(
            sessionId: "pvw_2756b51637c04c589030b17e8a2bf0b0",
            trackId: "apple:1726888402",
            streamUrl: "https://audio-ssl.itunes.apple.com/itunes-assets/AudioPreview112/v4/83/8a/0f/838a0fc8-538a-7f48-de7e-bb526d2c8bb0/mzaf_6419446688308081613.plus.aac.p.m4a",
            expiresAt: nil
        )
    )
}
