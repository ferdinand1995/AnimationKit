//
//  PatientPortalViewController.swift
//  AnimateTableViewHeader
//
//  Created by Ferdinand on 19/11/21.
//  Copyright © 2021 Thanh Nguyen. All rights reserved.
//

import UIKit

extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter({
            $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })

        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }

        return window

    }
    static var topSafeAreaHeight: CGFloat {
        var topHeight: CGFloat?
        if #available(iOS 11.0, *) {
            let window: UIWindow? = UIApplication
                .shared
                .connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
            topHeight = window?.safeAreaInsets.top
        }
        return topHeight ?? 0
    }

    static var bottomSafeAreaHeight: CGFloat {
        var bottomHeight: CGFloat?
        if #available(iOS 11.0, *) {
            let window: UIWindow? = UIApplication
                .shared
                .connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene }).flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
            bottomHeight = window?.safeAreaInsets.bottom
        }
        return bottomHeight ?? 0
    }
}

class PatientPortalViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationStackView: UIStackView!
    @IBOutlet private weak var navigationStackViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationStackViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var navigationBackgroundHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var backButton: UIButton!

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
        navigationStackView.subviews[1].alpha = percentage
        if let title: UILabel = navigationStackView.subviews[0] as? UILabel {
            let fontSize: CGFloat = (14 * percentage) + 18
            title.font = UIFont.systemFont(ofSize: fontSize)
        }

        navigationBackgroundHeightConstraint.constant = 88 - (88 * 2 * (1.0 - percentage))
        navigationStackViewTopConstraint.constant = minHeaderHeight - ((minHeaderHeight - 8) * (1 - percentage))

        let leadingRange = backButton.bounds.width - 8
        navigationStackViewLeadingConstraint.constant = leadingRange * (1.0 - percentage) + 16
    }
}

// MARK: UITableView Delegate
extension PatientPortalViewController: UITableViewDelegate, UITableViewDataSource {
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
        cell.textLabel?.text = "This is cell \(indexPath.row)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}

