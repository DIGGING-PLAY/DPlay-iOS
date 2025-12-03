//
//  UIViewController+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/25/25.
//

import UIKit

extension UIViewController {
    
    /// 키보드 이외의 영역 탭 시 키보드 내려가게 활성화
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
