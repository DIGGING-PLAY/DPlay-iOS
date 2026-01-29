//
//  ToastManager.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/27/25.
//

import UIKit

import SnapKit
import Then

final class ToastManager {
    
    static let shared = ToastManager()
    private init() {}
    
    // MARK: - Properties
    
    private var toastView: ToastView?
    private var hideWorkItem: DispatchWorkItem?
    private var isAnimating = false
    
    // MARK: - Public API
    
    func show(
        message: String,
        actionText: String? = nil,
        action: (() -> Void)? = nil
    ) {
        
        guard let window = UIApplication.shared.keyWindow else { return }
        
        // 기존 hide 예약 취소
        hideCurrentToast()
        
        let toast = ToastView()
        toast.configure(
            message: message,
            actionText: actionText,
            action: { [weak self] in
                action?()
                self?.hideCurrentToast()
            }
        )
        
        window.addSubview(toast)
        toastView = toast
        
        toast.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(window.safeAreaLayoutGuide).inset(80)
            $0.height.equalTo(56)
        }
        
        // 초기 상태
        toast.transform = CGAffineTransform(translationX: 0, y: 80)
        toast.alpha = 0
        
        // 등장 애니메이션
        UIView.animate(withDuration: 0.35) {
            toast.transform = .identity
            toast.alpha = 1
        }
        
        // 자동 숨김 예약
        let workItem = DispatchWorkItem { [weak self] in
            self?.hideCurrentToast()
        }
        hideWorkItem = workItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: workItem)
    }
    
    // MARK: - Private Methods
    
    private func hideCurrentToast(animated: Bool = true) {
        hideWorkItem?.cancel()
        hideWorkItem = nil
        
        guard let toast = toastView else { return }
        toastView = nil
        
        let animations = {
            toast.transform = CGAffineTransform(translationX: 0, y: 80)
            toast.alpha = 0
        }
        
        let completion: (Bool) -> Void = { _ in
            toast.removeFromSuperview()
        }
        
        if animated {
            UIView.animate(
                withDuration: 0.35,
                animations: animations,
                completion: completion
            )
        } else {
            animations()
            completion(true)
        }
    }
}
