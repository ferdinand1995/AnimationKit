//
//  MyTableViewController.swift
//  AnimateTableViewHeader
//
//  Created by Ferdinand on 13/12/21.
//  Copyright © 2021 Thanh Nguyen. All rights reserved.
//

import UIKit
import SnapKit

class AnimatedTableVC: UITableViewController {

    var colors = [UIColor.systemRed, UIColor.systemGreen, UIColor.systemBlue, UIColor.systemOrange, UIColor.systemYellow, UIColor.systemPink, UIColor.systemPurple, UIColor.systemTeal, UIColor.systemIndigo, UIColor.systemBrown, UIColor.systemMint, UIColor.systemCyan, UIColor.systemGray, UIColor.systemGray2, UIColor.systemGray3, UIColor.systemGray4, UIColor.systemGray5, UIColor.systemGray6]

    var animationsQueue = ChainedAnimationsQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellWithClass: TableViewCell.self)
        tableView.separatorStyle = .none

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(insert(_:)))
        /*
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batch Insert", style: .plain, target: self, action: #selector(insertBatch(_:)))*/
    }

    /*
    @objc func insertBatch(_ sender: UIBarButtonItem) {
        var indexPaths = [IndexPath]()
        for i in items.count...items.count + 5 {
            items.append("Item \(i + 1)")
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        var bottomHalfIndexPaths = [IndexPath]()
        for _ in 0...indexPaths.count / 2 - 1 {
            bottomHalfIndexPaths.append(indexPaths.removeLast())
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .right)
        tableView.insertRows(at: bottomHalfIndexPaths, with: .left)
        
        tableView.endUpdates()
    }
     */
    @objc func insert(_ sender: UIBarButtonItem) {
        /*items.append("Item \(items.count + 1)")
        
        let insertionIndexPath = IndexPath(row: items.count - 1, section: 0)
        
        tableView.insertRows(at: [insertionIndexPath], with: .middle)*/
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? TableViewCell else { return }
//        DispatchQueue.main.async {
//            cell.backgroundCardView.addShadow(shadowColor: .black, offSet: CGSize(width: 0, height: 3), opacity: 0.6, shadowRadius: 5.0, cornerRadius: 8, corners: [.allCorners], fillColor: self.colors[indexPath.row])
//        }
        cell.alpha = 0.0
        animationsQueue.queue(withDuration: 0.3, initializations: {
            cell.layer.transform = CATransform3DTranslate(CATransform3DIdentity, cell.frame.size.width, 0, 0)
        }, animations: {
                cell.alpha = 1.0
                cell.layer.transform = CATransform3DIdentity
            })
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return colors.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withClass: TableViewCell.self, for: indexPath)
        DispatchQueue.main.async {
            cell.backgroundCardView.addShadow(shadowColor: .black, offSet: CGSize(width: 0, height: 3), opacity: 0.6, shadowRadius: 5.0, cornerRadius: 8, corners: [.allCorners], fillColor: self.colors[indexPath.row])
        }
        return cell
    }

}

class TableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let backgroundCardView = UIView()

    let label: UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()

    private func initView() {
        self.selectionStyle = .none
        self.contentView.backgroundColor = .clear
        self.contentView.addSubview(backgroundCardView)
        backgroundCardView.addSubview(label)
//        backgroundCardView.layer.cornerRadius = 8
        initLayout()
    }

    private func initLayout() {
        backgroundCardView.snp.makeConstraints { make in
            backgroundCardView.snp.makeConstraints { make in
                make.top.equalToSuperview().offset(8)
                make.left.equalToSuperview().offset(8)
                make.bottom.equalToSuperview().offset(0)
                make.right.equalToSuperview().offset(-8)
            }
        }

        label.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview().offset(-16)
        }
    }
}

