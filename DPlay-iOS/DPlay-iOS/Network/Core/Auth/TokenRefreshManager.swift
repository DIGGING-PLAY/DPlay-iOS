//
//  TokenRefreshManager.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

final class TokenRefreshManager {

    static let shared = TokenRefreshManager()
    private init() {}

    private let keychain = KeychainManager.shared
    private var isRefreshing = false

    private var waiters: [CheckedContinuation<Bool, Never>] = []

    func refresh() async -> Bool {

        // 이미 다른 요청이 refresh 중이면 그 결과 기다림
        if isRefreshing {
            return await withCheckedContinuation { continuation in
                waiters.append(continuation)
            }
        }

        isRefreshing = true

        do {
            // 1) Refresh API 호출
            //            let response = try await BaseAPIService().request(
            //                AuthAPI.refreshToken,
            //                RefreshResponseDTO.self
            //            )

            // guard let data = response else { throw NetworkError.emptyData }

            // 2) 새로운 토큰 저장
            // keychain.accessToken = data.accessToken
            // keychain.refreshToken = data.refreshToken

            // 3) 대기 중인 다른 요청 모두 재개
            finishRefresh(success: true)

            return true

        } catch {
            print("🚨 Token Refresh Failed:", error)

            // 대기 요청 모두 실패 처리
            finishRefresh(success: false)

            return false
        }
    }

    private func finishRefresh(success: Bool) {
        isRefreshing = false
        waiters.forEach { $0.resume(returning: success) }
        waiters.removeAll()
    }
}
