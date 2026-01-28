//
//  AppEvent.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/29/26.
//

import Foundation
import Combine

enum AppEvent {
    case homeShouldRefresh(reason: HomeRefreshReason)
}

enum HomeRefreshReason {
    case commentAdded
    case commentDeleted
    case postAdded
    case likeToggled
    case scrapToggled
}

final class AppEventBus {
    static let shared = AppEventBus()
    private init() {}

    let event = PassthroughSubject<AppEvent, Never>()
}
