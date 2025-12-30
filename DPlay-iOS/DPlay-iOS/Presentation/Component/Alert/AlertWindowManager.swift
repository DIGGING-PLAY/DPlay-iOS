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
        //중복으로 띄우지 않도록 체크
        guard alertWindow == nil else { return }
        
        //현재 화면에 떠 있는 활성 Scene을 찾아서 할당
        guard let scene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else { return }
        
        //새로 띄울 window의 roorViewController 선언 및 배경 제거 -> 아래 화면 노출되도록
        let rootViewController = UIViewController()
        rootViewController.view.backgroundColor = .clear
        
        //윈도우 생성 및 위에서 찾은 scene과 매핑
        let window = UIWindow(windowScene: scene)
        window.rootViewController = rootViewController
        window.windowLevel = .alert + 1 //windowLevel을 최상단으로 보장
        window.backgroundColor = .clear
        window.isHidden = false
        window.makeKeyAndVisible() //키 윈도우 지정 및 화면에 표시
        
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
