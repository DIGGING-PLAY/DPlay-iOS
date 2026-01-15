//
//  MusicAddViewModel.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/25/25.
//

import SwiftUI
import Combine

@MainActor
final class MusicSearchViewModel: ObservableObject {

    // MARK: - State
    @Published private(set) var tracks: [MusicTrack] = []
    @Published private(set) var isEmpty: Bool = false
    @Published private(set) var isLoading: Bool = false

    private var currentKeyword: String?
    private var nextCursor: String?
    private var canLoadMore: Bool = true

    private let useCase: MusicSearchUseCase
    weak var coordinator: MusicAddCoordinator?

    init(
        useCase: MusicSearchUseCase,
        coordinator: MusicAddCoordinator?
    ) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

// MARK: - Coordinator

extension MusicSearchViewModel {
    func didTapBack() {
        coordinator?.dismiss()
    }
    
    func didTapNext(trackId: String) {
        coordinator?.goToMusicComment(trackId: trackId)
    }
}


extension MusicSearchViewModel {

    func search(keyword: String) async {
        guard !keyword.isEmpty else { return }

        // 초기화
        currentKeyword = keyword
        nextCursor = nil
        canLoadMore = true
        isLoading = true

        do {
            let result = try await useCase.searchTracks(
                keyword: keyword,
                cursor: nil
            )

            tracks = result.tracks
            nextCursor = result.nextCursor
            canLoadMore = result.nextCursor != nil
            isEmpty = result.tracks.isEmpty

        } catch {
            tracks = []
            isEmpty = true
            canLoadMore = false
        }

        isLoading = false
    }
}

extension MusicSearchViewModel {

    func loadMoreIfNeeded(currentIndex: Int) async {
        guard
            let keyword = currentKeyword,
            let cursor = nextCursor,
            canLoadMore,
            !isLoading,
            currentIndex >= tracks.count - 3   // 끝 근처에서만
        else { return }

        isLoading = true

        do {
            let result = try await useCase.searchTracks(
                keyword: keyword,
                cursor: cursor
            )

            tracks.append(contentsOf: result.tracks)
            nextCursor = result.nextCursor
            canLoadMore = result.nextCursor != nil

        } catch {
            canLoadMore = false
        }

        isLoading = false
    }
}
