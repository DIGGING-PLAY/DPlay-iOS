//
//  Nickname.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import Foundation

enum NicknameError: Error {
    case invalidLength
    case containsWhitespace
    case containsInvalidCharacter
}

struct Nickname {
    let value: String
    
    init(_ value: String) throws {
        guard value.count >= 2 && value.count <= 10 else { throw NicknameError.invalidLength }
        guard value.range(of: "\\s", options: .regularExpression) == nil else { throw NicknameError.containsWhitespace }
        guard value.range(of: "^[가-힣a-zA-Z0-9]+$", options: .regularExpression) != nil else { throw NicknameError.containsInvalidCharacter }
        
        self.value = value
    }
}
