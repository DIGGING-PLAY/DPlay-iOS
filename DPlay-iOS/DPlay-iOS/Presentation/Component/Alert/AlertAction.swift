//
//  AlertAction.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 12/15/25.
//

import UIKit

struct AlertAction {
    let buttonTitle: String
    let style: Style
    let onTap: (() -> Void)

    enum Style {
        case primaryRight
        case secondaryLeft
    }

    init(buttonTitle: String, style: Style = .primaryRight, onTap: @escaping (() -> Void)) {
        self.buttonTitle = buttonTitle
        self.style = style
        self.onTap = onTap
    }
}
