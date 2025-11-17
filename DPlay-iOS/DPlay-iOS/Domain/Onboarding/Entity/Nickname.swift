//
//  Nickname.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/17/25.
//

import Foundation

enum NicknameValidationState {
    case empty
    case normal
    case valid
    case invalid(NicknameError)
}

enum NicknameError: Error {
    case invalidLength
    case invalidCharacters
    case duplicate
}

struct Nickname {
    let value: String
    
    init(_ value: String) throws {
        guard value.range(of: "\\s", options: .regularExpression) == nil else { throw NicknameError.invalidCharacters }
        guard value.range(of: "^[가-힣a-zA-Z0-9]+$", options: .regularExpression) != nil else { throw NicknameError.invalidCharacters }
        guard value.count >= 2 else { throw NicknameError.invalidLength }

        self.value = value
    }
}
