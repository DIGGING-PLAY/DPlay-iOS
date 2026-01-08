//
//  PreviewMusicService.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/1/26.
//

import Foundation

protocol PreviewNetworkService {
    func requestPreview(
        trackId: String,
        storefront: String?
    ) async throws -> PreviewMusicResponseDTO
}

final class PreviewNetworkServiceImpl: PreviewNetworkService {

    private let apiService: BaseAPIService

    init(apiService: BaseAPIService = BaseAPIService()) {
        self.apiService = apiService
    }

    func requestPreview(
        trackId: String,
        storefront: String?
    ) async throws -> PreviewMusicResponseDTO {

        let result = await apiService.request(
            PreviewAPI.previewTrack(
                trackId: trackId,
                storefront: storefront
            ),
            PreviewMusicResponseDTO.self
        )

        switch result {

        case .success(let dto):
            guard let dto = dto else {
                throw AppError.emptyData
            }
            return dto

        case .unauthorized: throw AppError.unauthorized
        case .notFound:     throw AppError.notFound
        case .decodeError:  throw AppError.decodeError
        case .badRequest:   throw AppError.badRequest
        case .serverError:  throw AppError.serverError
        case .networkFail:  throw AppError.networkFail
        default:            throw AppError.unknown
        }
    }
}
