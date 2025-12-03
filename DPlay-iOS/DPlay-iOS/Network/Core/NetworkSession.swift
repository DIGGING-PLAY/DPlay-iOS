//
//  NetworkSession.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

import Alamofire

final class NetworkSession {
    static let shared = NetworkSession()
    
    let session: Session

    private init() {
        session = Session(
            interceptor: AuthInterceptor(),
            eventMonitors: [NetworkLogger()]
        )
    }
}
