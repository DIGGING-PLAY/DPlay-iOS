//
//  HomeViewUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

protocol HomeViewUseCase {
    func getHomeData() async throws -> HomeFeed
}

final class DefaultHomeViewUseCase: HomeViewUseCase {

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func getHomeData() async throws -> HomeFeed {
        let feed = try await repository.fetchHomeFeed()
        return feed  
    }
}
