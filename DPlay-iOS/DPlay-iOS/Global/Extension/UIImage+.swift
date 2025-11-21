//
//  UIImage+.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/14/25.
//

import UIKit


extension UIImage {
    
    /// 아이콘/이미지의 해상도 깨짐을 방지하며 지정된 크기로 리사이징
    func resized(to size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage ?? self
    }
}
