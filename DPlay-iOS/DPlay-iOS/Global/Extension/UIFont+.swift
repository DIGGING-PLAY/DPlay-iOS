//
//  UIFont+.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/2/25.
//

import UIKit

enum SuitFontWeight {
    case medium
    case semiBold
    case bold
}

enum DpalyFontStyle {
    case titleBold24
    case titleBold18
    case bodyBold16
    case bodySemi16
    case bodyMedi16
    case bodyBold14
    case bodySemi14
    case bodyMedi14
    case capMedi12
    
    var lineHeight: CGFloat {
        switch self {
        case .bodyBold14, .bodySemi14, .bodyMedi14:
            return 140
        default:
            return 130
        }
    }
}

extension UIFont {
    
    static func suitFont(size fontSize: CGFloat, weight: SuitFontWeight) -> UIFont {
        let fontName: String
        switch weight {
        case .medium: fontName = "SUIT-Medium"
        case .semiBold: fontName = "SUIT-SemiBold"
        case .bold: fontName = "SUIT-Bold"
        }
        
        guard let font = UIFont(name: fontName, size: fontSize) else { fatalError("Font not found") }
        return font
    }

    
    static func dplayFont(_ style: DpalyFontStyle) -> UIFont {
        switch style {
        case .titleBold24: return UIFont.suitFont(size: 24, weight: .bold)
        case .titleBold18: return UIFont.suitFont(size: 18, weight: .bold)
        case .bodyBold16: return UIFont.suitFont(size: 16, weight: .bold)
        case .bodySemi16: return UIFont.suitFont(size: 16, weight: .semiBold)
        case .bodyMedi16: return UIFont.suitFont(size: 16, weight: .medium)
        case .bodyBold14: return UIFont.suitFont(size: 14, weight: .bold)
        case .bodySemi14: return UIFont.suitFont(size: 14, weight: .semiBold)
        case .bodyMedi14: return UIFont.suitFont(size: 14, weight: .medium)
        case .capMedi12: return UIFont.suitFont(size: 12, weight: .medium)
        }
    }
    
}
