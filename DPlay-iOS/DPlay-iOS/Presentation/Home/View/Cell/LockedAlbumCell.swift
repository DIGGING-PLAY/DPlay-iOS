//
//  LockedAlbumCell.swift
//  DPlay-iOS
//
//  Created by 정정욱 on 1/4/26.
//

import UIKit

import SnapKit
import Then

final class LockedAlbumCell: UICollectionViewCell {

    static let identifier = LockedAlbumCell.className

    private let imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }
}

private extension LockedAlbumCell {

    func setupStyle() {
        imageView.image = ImageLiterals.img_lock
        imageView.contentMode = .scaleAspectFill
    }

    func setupHierarchy() {
        contentView.addSubviews(imageView)
    }

    func setupLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
