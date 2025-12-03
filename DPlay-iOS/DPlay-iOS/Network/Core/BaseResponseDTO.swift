//
//  BaseResponseDTO.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

struct BaseResponseDTO<T: Decodable>: Decodable {
    let success: Bool
    let code: Int
    let message: String
    let data: T?
}
