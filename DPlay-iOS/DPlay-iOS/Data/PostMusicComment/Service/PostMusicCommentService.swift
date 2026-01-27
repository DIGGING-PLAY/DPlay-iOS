//
//  PostMusicCommentService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/16/26.
//

import Foundation

protocol PostMusicCommentService {
    func fetchTrackDetail(trackId: String) async throws -> TrackDetailResponseDTO
    
    func createPost(request: PostMusicCommentRequestDTO) async throws -> PostMusicCommentResponseDTO
}

final class PostMusicCommentNetworkService: PostMusicCommentService {

    private let apiService: BaseAPIService

    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }
    
    func fetchTrackDetail(trackId: String) async throws -> TrackDetailResponseDTO {
        let result = await apiService.request(
            PostMusicCommentAPI.fetchTrackDetail(trackId: trackId, storefront: "kr"),
            TrackDetailResponseDTO.self
        )

        switch result {
        case .success(let dto):
            guard let dto else { throw AppError.emptyData }
            return dto
        case .unauthorized: throw AppError.unauthorized
        default: throw AppError.serverError
        }
    }
    
    func createPost(
        request: PostMusicCommentRequestDTO
    ) async throws -> PostMusicCommentResponseDTO {
        
        let result = await apiService.request(
            PostMusicCommentAPI.createPost(request: request),
            PostMusicCommentResponseDTO.self
        )
        
        switch result {
        case .success(let dto):
            guard let dto else { throw AppError.emptyData }
            return dto
        case .unauthorized:
            throw AppError.unauthorized
        default:
            throw AppError.serverError
        }
    }
}
