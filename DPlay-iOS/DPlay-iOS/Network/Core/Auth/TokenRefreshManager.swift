//
//  TokenRefreshManager.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/1/25.
//

import Foundation

actor TokenRefreshManager {

    static let shared = TokenRefreshManager()
    private init() {}

    private var isRefreshing = false

    private let authService = AuthServiceImpl()

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
            //1) Refresh API 호출
            let response = try await authService.refreshToken()
            guard let data = response.data else { throw AppError.emptyData }
            let userData = data.toEntity()

            KeychainManager.shared.accessToken = userData.accessToken
            KeychainManager.shared.refreshToken = userData.refreshToken
            UserDefaults.standard.set(userData.userId, forKey: "userId")

            //2) 대기 중인 다른 요청 모두 재개
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
