//
//  SignupRequestDTO.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/11/26.
//

import Foundation

struct SignupRequestDTO: Encodable {
    let platform: String
    let nickname: String
}
