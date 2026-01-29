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
    case mypageShouldRefresh(reason: MyPageRefreshReason)
}

enum HomeRefreshReason {
    case commentAdded
    case commentDeleted
    case postAdded
    case likeToggled
    case scrapToggled
}

enum MyPageRefreshReason {
    case commentAdded
    case commentDeleted
    case scrapToggled
    case pushNotificationToggled
    case profileUpdated
}

final class AppEventBus {
    static let shared = AppEventBus()
    private init() {}

    let event = PassthroughSubject<AppEvent, Never>()
}
