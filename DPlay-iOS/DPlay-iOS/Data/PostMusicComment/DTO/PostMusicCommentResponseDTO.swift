//
//  PostMusicCommentResponseDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/16/26.
//

import Foundation

typealias PostMusicCommentResponseDTO = BaseResponseDTO<PostMusicCommentDataDTO>

// 추후 에러시 내부 status 값으로 에러 대응 필요
struct PostMusicCommentDataDTO: Decodable {
    let postId: Int
}
