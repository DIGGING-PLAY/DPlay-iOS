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
    
    //MARK: - Properties
    
    private let userId: Int
    
    //MARK: - Dependencies
    
    private let useCase: MyPageUseCase
    weak var coordinator: MyPageCoordinating?
    
    //MARK: - Init
    
    init(useCase: MyPageUseCase, coordinator: MyPageCoordinating?, userId: Int) {
        self.useCase = useCase
        self.coordinator = coordinator
        self.userId = userId
    }
}

extension MyPageViewModel {
    
    //MARK: - Method
    
    func loadUserProfile() async {
        do {
            let result = try await useCase.getUserProfile(userId: userId)
            
            self.userProfileResult = result
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadRegisteredMusics() async {
        do {
            let result = try await useCase.getRegisteredTracks(userId: userId)
            
            self.registeredMusicsResult = result
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadArchiveMusics() async {
        do {
            let result = try await useCase.getArchiveTracks(userId: userId)

            self.archiveMusicsResult = result
        } catch {
            print("ERROR:", error)
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
    
    func popToPrevious() {
        coordinator?.pop()
    }
}
