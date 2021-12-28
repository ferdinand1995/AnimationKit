//
//  ViewController.swift
//  AnimateTableViewHeader
//
//  Created by Thanh Nguyen Xuan on 8/9/20.
//  Copyright © 2020 Thanh Nguyen. All rights reserved.
//

import UIKit
import Moya

enum HackerNewsAPI {
    case topStories
    case item(index: Int)
}

extension HackerNewsAPI: TargetType {
    var baseURL: URL {
        guard let url = URL(string: "https://hacker-news.firebaseio.com") else { fatalError("baseURL could not be configured.") }
        return url
    }

    var path: String {
        switch self {
        case .topStories:
            return "/v0/topstories.json"
        case .item(let index):
            return "/v0/item/\(index).json"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case .topStories:
            return .requestParameters(parameters: ["print": "pretty"], encoding: URLEncoding.queryString)
        case .item(_):
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}

class HackerNewsVC: UIViewController {

    // MARK: IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var logoImageView: UIImageView!
    @IBOutlet private weak var searchTextFieldTrailingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var chatButton: UIButton!
    @IBOutlet private weak var headerHeightConstraint: NSLayoutConstraint!

    // MARK: Properties
    private let maxHeaderHeight: CGFloat = 96.0
    private let minHeaderHeight: CGFloat = 48.0
    private var previousScrollOffset: CGFloat = 0.0

    var hackerNewsView: HackerNewsView?

    var newsArray = [NewsItem?]()
    var newsIDs: [Int]?

    let provider = MoyaProvider<HackerNewsAPI>()
    var cancellable: Cancellable?

    // MARK: View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        hackerNewsView = HackerNewsView(frame: self.view.frame)
        hackerNewsView?.tableView.dataSource = self
        hackerNewsView?.tableView.prefetchDataSource = self
        self.view.addSubview(hackerNewsView ?? UIView())
        hackerNewsView?.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableViewCell0")

        provider.request(.topStories) { result in
            switch result {
            case let .success(response):
                self.newsIDs = try? JSONDecoder().decode(NewsId.self, from: response.data)
                guard let count = self.newsIDs?.count else { return }
                self.newsArray = [NewsItem?](repeating: nil, count: count)
                DispatchQueue.main.async {
                    self.hackerNewsView?.tableView.reloadData()
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        headerHeightConstraint.constant = maxHeaderHeight
        self.updateHeader()
         */
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: Methods
    func fetchNews(withIndex index: Int) {
        guard let newsID = newsIDs?[index] else { return }
        provider.request(.item(index: newsID)) { result in
            switch result {
            case let .success(response):

                guard let news = try? JSONDecoder().decode(NewsItem.self, from: response.data) else { return }
                self.newsArray[index] = news
                // Update UI on main thread
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: index, section: 0)
                    if self.hackerNewsView?.tableView.indexPathsForVisibleRows?.contains(indexPath) ?? false {
                        self.hackerNewsView?.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                    }
                }
            case let .failure(error):
                print(error)
            }
        }
    }

    func cancelFetchNews(ofIndex index: Int) {
        guard let newsID = newsIDs?[index] else { return }
        cancellable = provider.request(.item(index: newsID), completion: { _ in
            })
        cancellable?.cancel()
    }

    private func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate height của scroll view khi header view bị collapse đến min height
        let scrollViewMaxHeight = scrollView.frame.height + headerHeightConstraint.constant - minHeaderHeight
        // Đảm bảo khi header bị collapse đến min height thì scroll view vẫn scroll được
        return scrollView.contentSize.height > scrollViewMaxHeight
    }

    private func setScrollPosition(_ position: CGFloat) {
        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: position)
    }

    private func scrollViewDidStopScrolling() {
        let range = maxHeaderHeight - minHeaderHeight
        let midPoint = minHeaderHeight + range / 2

        if headerHeightConstraint.constant > midPoint {
            // Expand header
            expandHeader()
        } else {
            // Collapse header
            collapseHeader()
        }
    }

    private func collapseHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    private func expandHeader() {
        view.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }

    private func updateHeader() {
        // Tính khoảng cách giữa 2 value max và min height
        let range = maxHeaderHeight - minHeaderHeight
        // Tính khoảng offset hiện tại với min height
        let openAmount = headerHeightConstraint.constant - minHeaderHeight
        // Tính tỉ lệ phần trăm để animate, thay đổi UI element
        let percentage = openAmount / range
        // Tính constant của trailing constraint cần thay đổi
        let trailingRange = view.frame.width - chatButton.frame.minX

        // Animate UI theo tỉ lệ tính được
        searchTextFieldTrailingConstraint.constant = trailingRange * (1.0 - percentage) + 8
        logoImageView.alpha = percentage
    }
}

// MARK: UITableViewDataSource methods
extension HackerNewsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell0", for: indexPath)
        if let news = newsArray[indexPath.row] {
            cell.textLabel?.text = news.title
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
        } else {
            cell.textLabel?.text = "Loading..."
            cell.textLabel?.textAlignment = .left
            self.fetchNews(withIndex: indexPath.row)
        }
        return cell
    }
}

extension HackerNewsVC: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self.fetchNews(withIndex: indexPath.row)
        }
    }

    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            self.cancelFetchNews(ofIndex: indexPath.row)
        }
    }
}

// MARK: UITableViewDataSource methods
extension HackerNewsVC: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset

        // Điểm giới hạn trên cùng của scroll view
        let absoluteTop: CGFloat = 0.0
        // Điểm giới hạn dưới cùng của scroll view
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height

        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom

        guard canAnimateHeader(scrollView) else {
            return
        }

        // Implement logic để animate header
        var newHeight = headerHeightConstraint.constant
        if isScrollingDown {
            newHeight = max(minHeaderHeight, headerHeightConstraint.constant - abs(scrollDiff))
        } else if isScrollingUp {
            newHeight = min(maxHeaderHeight, headerHeightConstraint.constant + abs(scrollDiff))
        }

        if newHeight != self.headerHeightConstraint.constant {
            headerHeightConstraint.constant = newHeight
            updateHeader()
            setScrollPosition(previousScrollOffset)
        }

        previousScrollOffset = scrollView.contentOffset.y
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        // Kết thúc scroll
        scrollViewDidStopScrolling()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            // Kết thúc scroll
            scrollViewDidStopScrolling()
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.item % 2 == 0 {
            /*if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: HealthTipsViewController.self)) as? HealthTipsViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            self.navigationController?.pushViewController(MyTableViewController(), animated: true)*/
        } else {
            if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: String(describing: PatientPortalViewController.self)) as? PatientPortalViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

