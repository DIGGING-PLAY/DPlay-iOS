//
//  NSObject+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/26/25.
//

import Foundation

extension NSObject {
    
    ///객체 이름 반환
    static var className: String {
        return String(describing: self)
    }
}
