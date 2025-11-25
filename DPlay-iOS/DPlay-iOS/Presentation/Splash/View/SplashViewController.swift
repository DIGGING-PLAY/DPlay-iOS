//
//  SplashViewController.swift
//  DPlay-iOS
//
//  Created by 조혜린 on 11/10/25.
//

import UIKit

import SnapKit
import Then

final class SplashViewController: UIViewController {
    
    //MARK: - UI Properties
    
    private let logoImageView = UIImageView(image: ImageLiterals.img_wordmark_white)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
}

private extension SplashViewController {
    
    //MARK: - setup
    
    func setupStyle() {
        view.backgroundColor = .dplay_pink
    }
    
    func setupHierarchy() {
        view.addSubview(logoImageView)
    }
    
    func setupLayout() {
        logoImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-68)
        }
    }
}
