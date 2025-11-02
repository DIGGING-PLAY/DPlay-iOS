//
//  UIColor+.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/1/25.
//

import UIKit

extension UIColor {
    static var dplay_pink = UIColor(hex: "#FF448B")
    static var dplay_pink300 = UIColor(hex: "#FF8FBA")
    static var dplay_pink100 = UIColor(hex: "#FFE3ED")
    
    static var gray100 = UIColor(hex: "#F7F8FC")
    static var gray200 = UIColor(hex: "#E5E7F0")
    static var gray300 = UIColor(hex: "#C7CCD3")
    static var gray400 = UIColor(hex: "#7F8A96")
    static var gray500 = UIColor(hex: "#4A555E")
    static var gray600 = UIColor(hex: "#31393F")
    static var dplay_black = UIColor(hex: "#14181B")
    
    static var alert_red = UIColor(hex: "#FC4649")
    static var info_blue = UIColor(hex: "#2C8BFF")
    static var kakao_yellow = UIColor(hex: "#FEE500")
    
    static let dplayPinkTrans = UIColor(hex: "#FF8FBA", alpha: 0.8)
    static let dim40 = UIColor(hex: "#14181B", alpha: 0.4)
    static let dim80 = UIColor(hex: "#14181B", alpha: 0.8)
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: alpha)
    }
}
