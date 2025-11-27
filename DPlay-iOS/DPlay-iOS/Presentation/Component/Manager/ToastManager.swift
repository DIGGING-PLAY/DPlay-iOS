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

    private var toastView: ToastView?

    // MARK: - Public API
    func show(
        message: String,
        actionText: String? = nil,
        action: (() -> Void)? = nil
    ) {
        guard let window = getKeyWindow() else { return }

        // 기존 토스트 제거
        toastView?.removeFromSuperview()

        let toast = ToastView()
        toast.configure(message: message, actionText: actionText, action: action)
        window.addSubview(toast)
        self.toastView = toast

        toast.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(window.safeAreaLayoutGuide).inset(80)
            $0.height.equalTo(56)
        }

        // 초기 위치 — 아래 숨기기
        toast.transform = CGAffineTransform(translationX: 0, y: 80)
        toast.alpha = 0

        // 등장 애니메이션
        UIView.animate(withDuration: 0.5) {
            toast.transform = .identity
            toast.alpha = 1
        }

        // 4초 뒤 자동 숨김
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            self?.hideToast()
        }
    }

    // MARK: - Private Methods
    private func hideToast() {
        guard let toast = toastView else { return }

        UIView.animate(withDuration: 0.5, animations: {
            toast.transform = CGAffineTransform(translationX: 0, y: 80)
            toast.alpha = 0
        }, completion: { _ in
            toast.removeFromSuperview()
        })
    }

    // 최신 Scene 기반 안전한 keyWindow 찾기
    private func getKeyWindow() -> UIWindow? {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return nil
        }
        return windowScene.windows.first { $0.isKeyWindow }
    }
}
