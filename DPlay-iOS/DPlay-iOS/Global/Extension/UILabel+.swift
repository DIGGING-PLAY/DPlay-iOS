//
//  UILabel+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/2/25.
//

import UIKit

extension UILabel {
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
}
