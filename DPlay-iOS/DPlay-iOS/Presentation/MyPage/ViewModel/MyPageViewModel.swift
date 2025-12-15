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
    
    @Published var userProfile: UserProfile?
    @Published var registeredMusics: MyPageMusics?
    @Published var archiveMusics: MyPageMusics?
    
    //MARK: - Dependencies
    
    private let useCase: MyPageUseCase
    weak var coordinator: MyPageCoordinator?
    
    //MARK: - Init
    
    init(useCase: MyPageUseCase, coordinator: MyPageCoordinator?) {
        self.useCase = useCase
        self.coordinator = coordinator
    }
}

extension MyPageViewModel {
    
    //MARK: - Method
    
    func loadUserProfile() async {
        do {
            let userProfile = try await useCase.getUserProfile()
            
            self.userProfile = userProfile
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadRegisteredMusics() async {
        do {
            let registeredMusics = try await useCase.getRegisteredTracks()
            
            self.registeredMusics = registeredMusics
        } catch {
            print("ERROR:", error)
        }
    }
    
    func loadArchiveMusics() async {
        do {
            let archiveMusics = try await useCase.getArchiveTracks()

            self.archiveMusics = archiveMusics
        } catch {
            print("ERROR:", error)
        }
    }
}

extension MyPageViewModel {
    
    // MARK: - Coordinator

    func goToProfileEdit() {
        coordinator?.goToProfileEdit()
    }
}
