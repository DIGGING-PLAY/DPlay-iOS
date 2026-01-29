//
//  MusicCommentViewModel.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/25/25.
//

import SwiftUI
import Combine

@MainActor
final class MusicCommentViewModel: ObservableObject {

    // MARK: - Dependency
    
    private let trackId: String
    private let useCase: PostMusicCommentUseCase
    weak var coordinator: MusicAddCoordinator?

    // MARK: - State
    
    @Published private(set) var track: MusicTrack?
    @Published private(set) var isLoading: Bool = false
    @Published var errorMessage: String?

    // MARK: - Init
    
    init(
        trackId: String,
        useCase: PostMusicCommentUseCase,
        coordinator: MusicAddCoordinator?
    ) {
        self.trackId = trackId
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

// MARK: - Coordinator

extension MusicCommentViewModel {
    func didTapBack() {
        coordinator?.pop()
    }
    
    func didTapRegister(comment: String) {
        guard let track else { return }

        let musicComment = MusicComment(
            trackId: track.trackId,
            songTitle: track.title,
            artistName: track.artist,
            coverImg: track.coverURL,
            isrc: track.isrc,
            content: comment
        )

        Task {
            do {
                _ = try await useCase.createPost(comment: musicComment)
                coordinator?.dismiss()
                AppEventBus.shared.event.send(
                    .homeShouldRefresh(reason: .commentAdded)
                )
            } catch {
                errorMessage = "코멘트 등록에 실패했습니다."
            }
        }
    }
}

extension MusicCommentViewModel {

    func onAppear() {
        Task {
            await fetchTrack()
        }
    }

    private func fetchTrack() async {
        isLoading = true

        do {
            track = try await useCase.fetchTrackDetail(trackId: trackId)
        } catch {
            errorMessage = "노래 정보를 불러오지 못했습니다."
        }

        isLoading = false
    }
}

