//
//  TodoView.swift
//  AnimationKit
//
//  Created by Ferdinand on 22/12/21.
//

import UIKit
import SnapKit

class ToDoView: UIView {
    
    var titleFontSize: CGFloat = 32
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_navigation")
        return imageView
    }()
    
    let navigationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "img_navigation_bg")
        return imageView
    }()
    
    let navigationView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    let calendarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "calendar")
        imageView.tintColor = .lightGray
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.textColor = .white
        return label
    }()

    let tableview: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        return tableView
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
        addSubview(backgroundImageView)
        addSubview(navigationImageView)
        addSubview(navigationView)
//        navigationView.addSubview(calendarImageView)
        navigationView.addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        addSubview(tableview)
        initLayout()
    }
    
    private func initLayout() {
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        navigationImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        navigationView.snp.makeConstraints { (make) -> Void in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(navigationImageView.snp.bottom)
            make.top.greaterThanOrEqualToSuperview().offset(16)
            make.bottom.greaterThanOrEqualToSuperview().offset(-16)
        }
        
        tableview.snp.makeConstraints { make in
            make.top.equalTo(self.navigationView.snp.bottom)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
}
