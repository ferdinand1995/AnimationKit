//
//  ToDoEmptyView.swift
//  AnimationKit
//
//  Created by Ferdinand on 22/12/21.
//

import UIKit
import SnapKit

class ToDoEmptyView: UIView {
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "to-do-list")
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "There is no task to do!"
        return label
    }()
    
    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = "Enjoy your time, you don't have any active task."
        return label
    }()
    
    let addTaskButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemTeal
        button.titleLabel?.textColor = .white
        button.setTitle("Add Task!", for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class var requiresConstraintBasedLayout: Bool {
        return true
    }

    // MARK: Initialize UI
    private func initUI() {
        backgroundColor = .white
        self.addSubview(contentView)
        contentView.addSubview(contentImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(subTitleLabel)
        contentView.addSubview(addTaskButton)
        addTaskButton.layer.cornerRadius = 8.0
        initLayout()
    }
    
    private func initLayout() {
        contentView.snp.makeConstraints { (make) -> Void in
            make.center.equalToSuperview()
        }
        
        contentImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
            make.width.height.equalTo(56)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.contentImageView.snp.bottom).offset(24)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(8)
        }
        
        addTaskButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitleLabel.snp.bottom).offset(24)
            make.height.equalTo(48)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.bottom.equalToSuperview().offset(-40)
        }
    }
}
