//
//  UIStackView+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/3/25.
//

import UIKit

extension UIStackView {
    
    func addArrangedSubviews(_ views: UIView...) {
        for view in views {
            self.addArrangedSubview(view)
        }
    }
    
}
