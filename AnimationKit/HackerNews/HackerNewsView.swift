//
//  HackerNewsView.swift
//  AnimationKit
//
//  Created by Ferdinand on 28/12/21.
//

import UIKit
import SnapKit

class HackerNewsView: UIView {
    
    var titleFontSize: CGFloat = 32
    var heightNavigationView: Constraint?
    var navigationImageViewBottom: Constraint?
    
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
        imageView.tintColor = .white
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today"
        label.textColor = .white
        return label
    }()

    let tableView: UITableView = {
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
        addSubview(tableView)
        initLayout()
    }
    
    private func initLayout() {
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            make.bottom.equalToSuperview()
        }
    }
}
