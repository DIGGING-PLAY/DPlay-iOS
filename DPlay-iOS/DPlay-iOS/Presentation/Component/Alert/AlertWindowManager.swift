//
//  AlertWindowManager.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/15/25.
//

import UIKit

final class AlertWindowManager {
    
    static let shared = AlertWindowManager()
    private init() {}
    
    private var alertWindow: UIWindow?
}

extension AlertWindowManager {
    
    //MARK: - Method
    
    func present(
        title: String?,
        message: String? = nil,
        actions: [AlertAction],
    ) {
        guard alertWindow == nil else { return }
        
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else { return }
        
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .clear
        
        let window = UIWindow(windowScene: scene)
        window.rootViewController = rootViewController
        window.windowLevel = .alert + 1
        window.backgroundColor = .clear
        window.isHidden = false
        window.makeKeyAndVisible()
        
        alertWindow = window
        
        let alertVC = AlertViewController(
            title: title,
            message: message,
            actions: actions,
            onDismiss: { [weak self] in
                self?.dismiss()
            }
        )
        
        rootViewController.present(alertVC, animated: false)
    }
    
    func dismiss() {
        alertWindow?.isHidden = true
        alertWindow?.rootViewController = nil
        alertWindow = nil
    }
}
