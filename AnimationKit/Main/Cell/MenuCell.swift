//
//  MenuCell.swift
//  AnimationKit
//
//  Created by Ferdinand on 20/12/21.
//

import UIKit
import SnapKit

class MenuCell: UICollectionViewCell {

    let backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initCell()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initCell() {
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(backgroundCardView)
        self.backgroundCardView.addSubview(titleLabel)
        initLayout()
    }

    private func initLayout() {
        backgroundCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(-16)
        }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.left.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
            make.right.equalToSuperview().offset(-8)
        }
    }
}
