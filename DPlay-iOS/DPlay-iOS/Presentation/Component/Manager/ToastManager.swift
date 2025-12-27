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
        guard let window = getKeyWindow() else { return }

        // 기존 hide 예약 취소
        hideWorkItem?.cancel()
        hideWorkItem = nil

        // 기존 토스트가 있다면 애니메이션으로 제거
        if toastView != nil {
            hideToast(animated: false)
        }

        let toast = ToastView()
        toast.configure(
            message: message,
            actionText: actionText,
            action: { [weak self] in
                action?()
                self?.hideToast()
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
            self?.hideToast()
        }
        hideWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: workItem)
    }

    // MARK: - Private Methods

    private func hideToast(animated: Bool = true) {
        guard let toast = toastView, !isAnimating else { return }

        isAnimating = true
        hideWorkItem?.cancel()
        hideWorkItem = nil

        let animations = {
            toast.transform = CGAffineTransform(translationX: 0, y: 80)
            toast.alpha = 0
        }

        let completion: (Bool) -> Void = { [weak self] _ in
            toast.removeFromSuperview()
            self?.toastView = nil
            self?.isAnimating = false
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

    // 최신 Scene 기반 keyWindow 획득
    private func getKeyWindow() -> UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
