//
//  MyPageViewModel.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/2/25.
//

import SwiftUI
import Combine

@MainActor
final class MyPageViewModel: ObservableObject {
    
    //MARK: - Property Wrappers
    
    @Published var userProfileResult: MyPageUserProfileResult?
    @Published var registeredMusicsResult: MyPageTrackResult?
    @Published var archiveMusicsResult: MyPageTrackResult?
    @Published var registeredMusics: [MyPageTrackPost] = []
    
    //MARK: - Properties
    
    private let userId: Int
    private var cancellables = Set<AnyCancellable>()
    private var nextCursor: String?
    
    //MARK: - Dependencies
    
    private let myPageUseCase: MyPageUseCase
    private let commentDetailUseCase: MusicCommentDetailUseCase
    weak var coordinator: DetailCoordinating?
    
    //MARK: - Init
    
    init(myPageUseCase: MyPageUseCase, commentDetailUseCase: MusicCommentDetailUseCase, coordinator: DetailCoordinating?, userId: Int) {
        self.myPageUseCase = myPageUseCase
        self.commentDetailUseCase = commentDetailUseCase
        self.coordinator = coordinator
        self.userId = userId
        
        bindAppEvent()
    }
}

extension MyPageViewModel {
    
    //MARK: - Method
    
    func loadUserProfile() async {
        do {
            let result = try await myPageUseCase.getUserProfile(userId: userId)
            
            self.userProfileResult = result
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadRegisteredMusics() async {
        do {
            let result = try await myPageUseCase.getRegisteredTracks(userId: userId, cursor: nextCursor)
            
            self.registeredMusicsResult = result
            self.nextCursor = result.nextCursor
            self.registeredMusics = result.musics.items
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadArchiveMusics() async {
        do {
            let result = try await myPageUseCase.getArchiveTracks(userId: userId)

            self.archiveMusicsResult = result
        } catch {
            print("ERROR:", error)
        }
    }
    
    func deletePost(postId: Int) async {
        do {
            try await commentDetailUseCase.deletePost(postId: postId)
            AppEventBus.shared.event.send(
                .homeShouldRefresh(reason: .commentDeleted)
            )
            AppEventBus.shared.event.send(
                .mypageShouldRefresh(reason: .commentDeleted)
            )
        } catch {
            print("❌ 삭제 실패:", error)
        }
    }
    
    func loadRegisteredMusicsMoreIfNeeded(currentIndex: Int) async {
        guard let cursor = nextCursor,
              currentIndex >= registeredMusics.count - 3 else { return }

        do {
            let result = try await myPageUseCase.getRegisteredTracks(userId: userId, cursor: cursor)

            registeredMusics.append(contentsOf: result.musics.items)
            nextCursor = result.nextCursor
        } catch {
            nextCursor = nil
        }
    }
    
    func resetCursor() {
        nextCursor = nil
    }
}

// MARK: - AppEvent Binding

private extension MyPageViewModel {
    func bindAppEvent() {
        AppEventBus.shared.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }

                switch event {
                case let .mypageShouldRefresh(reason):
                    self.handleMyPageRefresh(reason)
                default:
                    break
                }
            }
            .store(in: &cancellables)
    }
    
    func handleMyPageRefresh(_ reason: MyPageRefreshReason) {
        switch reason {
        case .commentAdded:
            Task { await loadRegisteredMusics() }
            Task { await loadUserProfile() }
        case .commentDeleted:
            Task { await loadUserProfile() }
            Task { await loadRegisteredMusics() }
            Task { await loadArchiveMusics() }
        case .scrapToggled:
            Task { await loadArchiveMusics() }
        case .pushNotificationToggled, .profileUpdated:
            Task { await loadUserProfile() }
        }
    }
}

extension MyPageViewModel {
    
    // MARK: - Coordinator

    func goToProfileEdit(profileImage: UIImage? = nil) {
        let nickname = userProfileResult?.profile.user.nickname ?? ""
        
        (coordinator as? MyPageCoordinator)?.goToProfileEdit(nickname: nickname, profileImg: profileImage)
    }
    
    func goToSetting() {
        let pushOn = userProfileResult?.pushOn ?? false
        
        (coordinator as? MyPageCoordinator)?.goToSetting(pushOn: pushOn)
    }
    
    func goToMusicDetail(trackId: String) {
        guard let postId = Int(trackId) else { return }

        coordinator?.goToMusicCommentDetail(
            postId: postId,
            badge: .nomal
        )
    }
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
