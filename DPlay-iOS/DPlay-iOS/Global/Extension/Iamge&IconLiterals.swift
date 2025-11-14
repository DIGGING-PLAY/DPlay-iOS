//
//  IconLiterals.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/10/25.
//

import UIKit

enum IconLiterals {
    static var ic_refresh: UIImage { .load(name: "ic_refresh_20") }
    static var ic_stream: UIImage { .load(name: "ic_stream_32") }
    static var ic_quote_up: UIImage { .load(name: "ic_quote_16_up") }
    static var ic_quote_down: UIImage { .load(name: "ic_quote_16_down") }
    static var ic_heart_w: UIImage { .load(name: "ic_heart_w_24") }
    static var ic_editor: UIImage { .load(name: "ic_editor_20") }
    static var ic_dplay_smallLogo: UIImage { .load(name: "ic_dplay_smallLogo") }
    static var ic_dplay_bigLogo: UIImage { .load(name: "ic_dplay_bigLogo") }
    static var ic_bookmark_24: UIImage { .load(name: "ic_bookmark_24") }
    static var ic_bookmark_fill_24: UIImage { .load(name: "ic_bookmark_fill_24") }
    static var ic_list_24: UIImage { .load(name: "ic_list_24") }
}

enum ImageLiterals {
    static var img_card_cover: UIImage { .load(name: "img_card_cover") }
    static var img_mock_profile: UIImage { .load(name: "img_mock_profile") }
}

extension UIImage {
    static func load(name: String) -> UIImage {
        guard let image = UIImage(named: name, in: nil, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }


    static func load(systemName: String) -> UIImage {
        guard let image = UIImage(systemName: systemName, compatibleWith: nil) else {
            return UIImage()
        }
        return image
    }
}
