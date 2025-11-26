//
//  UILabel+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/2/25.
//

import UIKit

extension UILabel {
    
    ///UILabel에 스타일 가이드 기반 폰트 스타일 적용
    func setTextStyle(_ fontStyle: DpalyFontStyle){
        let font = UIFont.dplayFont(fontStyle)
        let fontHeight = font.pointSize
        let fontSpacing = round(fontHeight * (fontStyle.lineHeight - 100) / 100)
        
        if let text = text {
            let style = NSMutableParagraphStyle()
            
            style.maximumLineHeight = fontHeight + fontSpacing
            style.minimumLineHeight = fontHeight + fontSpacing

            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .paragraphStyle: style,
            ]
            
            let attrString = NSAttributedString(string: text,
                                                attributes: attributes)
            self.attributedText = attrString
        }
    }
    
    ///UILabel에 밑줄 추가
    ///targetText 지정 시 특정 문자열에만 적용 가능
    func setUnderline(targetText: String? = nil) {
        let targetText = targetText ?? self.text ?? ""
        let attributedString: NSMutableAttributedString

        if let existing = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: existing)
        } else {
            attributedString = NSMutableAttributedString(string: targetText)
        }
        
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }

}
