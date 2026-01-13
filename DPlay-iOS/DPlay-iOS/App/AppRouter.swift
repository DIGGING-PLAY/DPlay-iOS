//
//  AppRouter.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/12/26.
//

enum AppRoute {
    case auth
    case mainTabBar
}

final class AppRouter {
    var onRouteChange: ((AppRoute) -> Void)?

    func goAuth() { onRouteChange?(.auth) }
    func goMainTabBar() { onRouteChange?(.mainTabBar) }
}
