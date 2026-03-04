//
//  HomeFeedBadgeView.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/4/26.
//

import UIKit

final class BadgeView: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseStyle()
        isHidden = true
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BadgeView {

    func setupBaseStyle() {
        backgroundColor = .white
        layer.borderWidth = 1
        layer.cornerRadius = 16
    }
}

private extension BadgeView {

    var badgeColor: UIColor {
        .dplay_pink
    }

    func titleText(for badge: Badge) -> String {
        switch badge {
        case .editor: return "EDITOR"
        case .best:   return "BEST"
        case .new:    return "NEW"
        case .normal:
            fatalError("normal badge should not be configured")
        }
    }

    func icon(for badge: Badge) -> UIImage {
        switch badge {
        case .editor: return IconLiterals.ic_editor
        case .best:   return IconLiterals.ic_best
        case .new:    return IconLiterals.ic_new
        case .normal:
            fatalError("normal badge should not be configured")
        }
    }
}

extension BadgeView {

    func configure(badge: Badge) {

        // normal이면 숨김 처리
        guard badge != .normal else {
            hide()
            return
        }

        var config = UIButton.Configuration.plain()
        config.image = icon(for: badge)
        config.imagePadding = 4
        config.baseForegroundColor = badgeColor

        var title = AttributedString(titleText(for: badge))
        title.font = .dplayFont(.bodySemi14)
        title.foregroundColor = badgeColor
        config.attributedTitle = title

        configuration = config
        layer.borderColor = badgeColor.cgColor
        isHidden = false
    }

    func hide() {
        isHidden = true
        configuration = nil
    }
}


