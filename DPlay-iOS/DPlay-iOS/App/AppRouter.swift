//
//  AppRouter.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 1/12/26.
//

enum AppRoute {
    case auth
    case onboarding(appleIdentityToken: String)
    case mainTabBar
}

final class AppRouter {
    var onRouteChange: ((AppRoute) -> Void)?

    func goToAuth() { onRouteChange?(.auth) }
    func goToOnboarding(appleIdentityToken: String) {
        onRouteChange?(.onboarding(appleIdentityToken: appleIdentityToken))
    }
    func goToMainTabBar() { onRouteChange?(.mainTabBar) }
}
