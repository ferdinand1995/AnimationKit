//
//  HealthTipsViewController.swift
//  AnimateTableViewHeader
//
//  Created by Ferdinand on 29/11/21.
//  Copyright © 2021 Thanh Nguyen. All rights reserved.
//

import UIKit

class HealthTipsViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var imageBackgroundBottomConstraint: NSLayoutConstraint!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var titleLabelTopConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    private let maxHeaderHeight: CGFloat = 192 - UIApplication.topSafeAreaHeight
    private let minHeaderHeight: CGFloat = 56.0
    private var previousScrollOffset: CGFloat = 0.0

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell1")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerHeightConstraint.constant = maxHeaderHeight
        self.updateHeader()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Animation Header
    private func isPossibleToAnimate(withHeader scrollView: UIScrollView) -> Bool {
        let scrollViewMaxHeight = scrollView.frame.height + headerHeightConstraint.constant - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    private func scrollViewDidStopScrolling() {
        let range = maxHeaderHeight - minHeaderHeight
        let midPoint = minHeaderHeight + range / 2
        animateHeader(headerHeightConstraint.constant > midPoint)
    }

    private func animateHeader(_ isExpanding: Bool) {
        view.layoutIfNeeded()
        if isExpanding {
            UIView.animate(withDuration: 0.3, animations: {
                self.headerHeightConstraint.constant = self.maxHeaderHeight
                self.updateHeader()
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.headerHeightConstraint.constant = self.minHeaderHeight
                self.updateHeader()
                self.view.layoutIfNeeded()
            })
        }
    }

    private func updateHeader() {
        let range = maxHeaderHeight - minHeaderHeight
        let openAmount: CGFloat = headerHeightConstraint.constant - minHeaderHeight
        let percentage: CGFloat = openAmount / range
        let fontSize: CGFloat = (14 * percentage) + 18
        titleLabel.font = UIFont.systemFont(ofSize: fontSize)
        imageBackgroundBottomConstraint.constant = 88 * (1.0 - percentage)
    }
}

// MARK: UITableView Delegate
extension HealthTipsViewController: UITableViewDelegate, UITableViewDataSource {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset

        let absoluteTop: CGFloat = 0.0
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isReachingTop = scrollView.contentOffset.y <= absoluteTop

        guard isPossibleToAnimate(withHeader: scrollView) else {
            return
        }

        var newHeight: CGFloat = headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
        } else if isReachingTop {
            newHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
        }

        if newHeight != self.headerHeightConstraint.constant {
            headerHeightConstraint.constant = newHeight
            updateHeader()
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: previousScrollOffset)
        }

        previousScrollOffset = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollViewDidStopScrolling()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell1", for: indexPath)
        cell.textLabel?.text = "This is cell Injection \(indexPath.row)"
        return cell
    }
}

