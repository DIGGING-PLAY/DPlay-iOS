//
//  UITextField+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/3/25.
//

import UIKit

extension UITextField {
    
    func addPadding(left: CGFloat? = nil, right: CGFloat? = nil) {
        if let leftPadding = left {
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: leftPadding, height: 0))
            leftViewMode = .always
        }
        if let rightPadding = right {
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: rightPadding, height: 0))
            rightViewMode = .always
        }
    }
    
}

extension UITextField {

    /// Typography 기반 텍스트 스타일 적용 (UILabel과 동일한 규칙)
    func setTextStyle(_ fontStyle: DpalyFontStyle) {
        let font = UIFont.dplayFont(fontStyle)
        let fontHeight = font.pointSize
        let fontSpacing = round(fontHeight * (fontStyle.lineHeight - 100) / 100)

        let paragraph = NSMutableParagraphStyle()
        paragraph.maximumLineHeight = fontHeight + fontSpacing
        paragraph.minimumLineHeight = fontHeight + fontSpacing

        // 현재 텍스트가 있는 경우 → attributedText로 스타일 적용
        if let text = self.text, !text.isEmpty {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: paragraph
            ]
            self.attributedText = NSAttributedString(string: text, attributes: attributes)
        } else {
            // 글자가 아직 없더라도 기본 typingAttributes를 세팅해야 함
            self.typingAttributes = [
                .font: font,
                .paragraphStyle: paragraph
            ]
        }
        
        // 기본 font에도 반영 (커서 높이가 정상적으로 보이게)
        self.font = font
    }

    /// Placeholder도 Typography 적용 가능하게 확장
    func setPlaceholder(_ text: String, fontStyle: DpalyFontStyle, color: UIColor = .gray400) {
        let font = UIFont.dplayFont(fontStyle)
        let fontHeight = font.pointSize
        let fontSpacing = round(fontHeight * (fontStyle.lineHeight - 100) / 100)

        let paragraph = NSMutableParagraphStyle()
        paragraph.maximumLineHeight = fontHeight + fontSpacing
        paragraph.minimumLineHeight = fontHeight + fontSpacing

        self.attributedPlaceholder = NSAttributedString(
            string: text,
            attributes: [
                .font: font,
                .foregroundColor: color,
                .paragraphStyle: paragraph
            ]
        )
    }
}
