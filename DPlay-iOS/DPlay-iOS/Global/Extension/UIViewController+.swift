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
        tap.cancelsTouchesInView = false // 키보드도 내려가고 기존 터치도 정상 동작 테이블, 컬렉션 터치 씹힘 방지
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
