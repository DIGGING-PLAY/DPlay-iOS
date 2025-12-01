//
//  Encodable+.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

extension Encodable {
    func toDictionary() -> [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    }
}
