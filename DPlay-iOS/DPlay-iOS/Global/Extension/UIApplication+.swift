//
//  UIApplication+.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 12/28/25.
//

import UIKit

/// UIWindow는 화면 전체를 담당하는 루트 컨테이너 여기 위에 추가하면 전체 화면 최상단에 추가 가능
/// 팝업을 탭바 영역까지 적용하기 위함
/*
 UIKit 전체 계층 구조
 iOS System
   ↓
 UIApplication
   ↓
 UIScene (iOS 13+)
   ↓
 UIWindowScene
   ↓
 UIWindow
   ↓
 UIViewController
   ↓
 UIView
 
 사용법 guard let window = UIApplication.shared.keyWindow else { return }
*/
extension UIApplication {

    /// 현재 활성화된 Key Window 반환
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
