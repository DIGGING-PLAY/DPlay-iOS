//
//  IconLiterals.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 11/10/25.
//

import UIKit

enum IconLiterals {
    static var ic_refresh: UIImage { .load(name: "ic_refresh_20") }
    static var ic_stream_p: UIImage { .load(name: "ic_stream_p_32") }
    static var ic_stream_w: UIImage { .load(name: "ic_stream_w_32") }
    static var ic_quote_up: UIImage { .load(name: "ic_quote_16_up") }
    static var ic_quote_down: UIImage { .load(name: "ic_quote_16_down") }
    static var ic_heart_w: UIImage { .load(name: "ic_heart_w_24") }
    static var ic_heart_p: UIImage { .load(name: "ic_heart_p_24") }
    static var ic_editor: UIImage { .load(name: "ic_editor_20") }
    static var ic_dplay_smallLogo: UIImage { .load(name: "ic_dplay_smallLogo") }
    static var ic_dplay_bigLogo: UIImage { .load(name: "ic_dplay_bigLogo") }
    static var ic_bookmark_24: UIImage { .load(name: "ic_bookmark_24") }
    static var ic_bookmark_fill_24: UIImage { .load(name: "ic_bookmark_fill_24") }
    static var ic_floating: UIImage { .load(name: "ic_floating") }
    static var ic_tabbar_home: UIImage { .load(name: "ic_tabbar_home") }
    static var ic_list_24: UIImage { .load(name: "ic_list_24") }
    static var ic_tabbar_home_select: UIImage { .load(name: "ic_tabbar_home_select") }
    static var ic_tabbar_mypage: UIImage { .load(name: "ic_tabbar_mypage") }
    static var ic_tabbar_mypage_select: UIImage { .load(name: "ic_tabbar_mypage_select") }
    static var ic_search_20: UIImage { .load(name: "ic_search_20") }
    static var ic_check_circle_24: UIImage { .load(name: "ic_check_circle_24") }
    static var ic_check_circle_20: UIImage { .load(name: "ic_check_circle_20") }
    static var ic_info_20: UIImage { .load(name: "ic_info_20") }
    static var ic_close_white: UIImage { .load(name: "ic_close_white") }
    static var ic_close_20: UIImage { .load(name: "ic_close_20") }
    static var ic_close_24: UIImage { .load(name: "ic_close_24") }
    static var ic_polygon: UIImage { .load(name: "ic_polygon") }
    static var ic_arrow_right_16: UIImage { .load(name: "ic_arrow_right_16") }
    static var ic_check_circle_default_24: UIImage { .load(name: "ic_check_circle_default_24") }
    static var ic_check_circle_selected_24: UIImage { .load(name: "ic_check_circle_selected_24") }
    static var ic_back_48: UIImage { .load(name: "ic_back_48") }
    static var ic_apple_24: UIImage { .load(name: "ic_apple_24") }
    static var ic_circle_close: UIImage { .load(name: "ic_circle_close") }
    static var ic_circle_plus: UIImage { .load(name: "ic_circle_plus") }
    static var ic_alert_24: UIImage { .load(name: "ic_alert_24")}
    static var ic_circle_edit: UIImage { .load(name: "ic_circle_edit") }
    static var ic_more_g_20: UIImage { .load(name: "ic_more_g_20") }
    static var ic_setting_24: UIImage { .load(name: "ic_setting_24") }
    static var ic_play_28: UIImage { .load(name: "ic_play_28") }
}

enum ImageLiterals {
    static var img_card_cover: UIImage { .load(name: "img_card_cover") }
    static var img_mock_profile: UIImage { .load(name: "img_mock_profile") }
    static var img_back: UIImage { .load(name: "img_back") }
    static var img_dot_menu: UIImage { .load(name: "img_dot_menu") }
    static var img_wordmark_pink: UIImage { .load(name: "img_wordmark_pink") }
    static var img_wordmark_white: UIImage { .load(name: "img_wordmark_white") }
    static var img_key: UIImage { .load(name: "img_key") }
    static var img_onboarding_1: UIImage { .load(name: "img_onboarding_1") }
    static var img_onboarding_2: UIImage { .load(name: "img_onboarding_2") }
    static var img_onboarding_3: UIImage { .load(name: "img_onboarding_3") }
    static var img_profile: UIImage { .load(name: "img_profile")}
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
