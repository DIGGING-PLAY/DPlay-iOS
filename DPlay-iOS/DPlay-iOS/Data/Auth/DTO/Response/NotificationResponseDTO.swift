//
//  NotificationResponseDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/29/26.
//

typealias NotificationResponseDTO = BaseResponseDTO<NotificationDataDTO>

struct NotificationDataDTO: Decodable {
    let pushOn: Bool
}
