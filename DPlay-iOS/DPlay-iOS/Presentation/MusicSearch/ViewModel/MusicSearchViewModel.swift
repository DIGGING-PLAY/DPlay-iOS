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
    @Published private(set) var tracks: [Track] = []
    @Published private(set) var isEmpty: Bool = false
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var hasSearched: Bool = false
    
    private var currentKeyword: String?
    private var nextCursor: String?
    private var canLoadMore: Bool = true
    private var searchTask: Task<Void, Never>?

    private let useCase: MusicSearchUseCase
    weak var coordinator: MusicAddCoordinator?

    deinit {
        searchTask?.cancel()
    }

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

    func searchWithDebounce(keyword: String) {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            await search(keyword: keyword)
        }
    }

    func cancelSearch() {
        searchTask?.cancel()
    }

    func search(keyword: String) async {
        guard !keyword.isEmpty else { return }

        // 초기화
        hasSearched = true
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
    
    func clearResults() {
        tracks = []
        isEmpty = false
        isLoading = false
        hasSearched = false
        currentKeyword = nil
        nextCursor = nil
        canLoadMore = false
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
