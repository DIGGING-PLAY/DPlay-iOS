//
//  UINavigationController+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/29/25.
//

import UIKit

extension UINavigationController {
    func rootTabBarController() -> MainTabBarController? {
        view.window?.rootViewController as? MainTabBarController
    }
}
