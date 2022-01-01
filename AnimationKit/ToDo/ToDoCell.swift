//
//  ToDoCell.swift
//  AnimationKit
//
//  Created by Ferdinand on 31/12/21.
//

import UIKit
import SnapKit

class ToDoCell: UITableViewCell {

    let backgroundCardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24)
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initCell()
        self.selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initCell() {
        contentView.addSubview(backgroundCardView)
        backgroundCardView.addSubview(stackView)
        [titleLabel, subTitleLabel].forEach { stackView.addArrangedSubview($0) }
        backgroundCardView.addSubview(timeLabel)
        timeLabel.setContentHuggingPriority(.required, for: .horizontal)
        initLayout()
    }

    private func initLayout() {
        backgroundCardView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(0)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.leading.equalToSuperview().offset(8)
            make.bottom.equalToSuperview().offset(-8)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
            make.leading.equalTo(stackView.snp.trailing).offset(8)
        }
    }
}
