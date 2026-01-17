//
//  UIImageView+.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/16/26.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(url: URL) {
        self.kf.setImage(
            with: url,
            placeholder: UIImage(named: "img_placeholder"),
            options: [
                .transition(.fade(0.2)),
                .cacheOriginalImage
            ]
        )
    }
}
