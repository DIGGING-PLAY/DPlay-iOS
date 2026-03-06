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
    @Published var registeredMusics: [MyPageTrackPost] = []
    @Published var archiveMusics: [MyPageTrackPost] = []

    //MARK: - Properties

    private let userId: Int
    private var cancellables = Set<AnyCancellable>()
    private var nextCursor: String?
    private var refreshTask: Task<Void, Never>?
    var isHost: Bool?
    
    //MARK: - Dependencies
    
    private let myPageUseCase: MyPageUseCase
    private let commentDetailUseCase: MusicCommentDetailUseCase
    weak var coordinator: DetailCoordinating?
    
    deinit {
        refreshTask?.cancel()
    }

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
            let result = try await myPageUseCase.getRegisteredTracks(userId: userId, cursor: nil)

            self.nextCursor = result.nextCursor
            self.isHost = result.isHost
            self.registeredMusics = result.musics.items
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadArchiveMusics() async {
        do {
            let result = try await myPageUseCase.getArchiveTracks(userId: userId, cursor: nil)

            self.nextCursor = result.nextCursor
            self.archiveMusics = result.musics.items
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
    
    func loadRegisteredMusicsMore(currentIndex: Int) async {
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
    
    func loadArchiveMusicsMore(currentIndex: Int) async {
        guard let cursor = nextCursor,
              currentIndex >= archiveMusics.count - 3 else { return }

        do {
            let result = try await myPageUseCase.getArchiveTracks(userId: userId, cursor: cursor)

            archiveMusics.append(contentsOf: result.musics.items)
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
        refreshTask?.cancel()
        refreshTask = Task {
            switch reason {
            case .commentAdded:
                async let p: () = loadRegisteredMusics()
                async let q: () = loadUserProfile()
                _ = await (p, q)
            case .commentDeleted:
                async let a: () = loadUserProfile()
                async let b: () = loadRegisteredMusics()
                async let c: () = loadArchiveMusics()
                _ = await (a, b, c)
            case .scrapToggled:
                await loadArchiveMusics()
            case .pushNotificationToggled, .profileUpdated:
                await loadUserProfile()
            }
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
            badge: .normal
        )
    }
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
