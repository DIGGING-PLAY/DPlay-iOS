//
//  HomeViewUseCase.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/7/25.
//

import Foundation

protocol HomeViewUseCase {
    func getHomeData() async throws -> (Question, [Post])
}

final class DefaultHomeViewUseCase: HomeViewUseCase {

    private let repository: HomeRepository

    init(repository: HomeRepository) {
        self.repository = repository
    }

    func getHomeData() async throws -> (Question, [Post]) {
        let dataDTO = try await repository.fetchHomeFeed()
        let question = Question(
            id: dataDTO.questionId,
            date: dataDTO.date,
            hasPosted: dataDTO.hasPosted
        )
        let posts = dataDTO.items.map { $0.toEntity() }

        return (question, posts)
    }
}
