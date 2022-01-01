//
//  ToDoVC.swift
//  AnimationKit
//
//  Created by Ferdinand on 21/12/21.
//

import UIKit
import SnapKit

struct TaskTodo: Codable {
    let titleTask: String
    let subtitleTask: String
}

class ToDoVC: UIViewController {

    var toDoView: ToDoView?
    var toDoEmptyView: ToDoEmptyView?
    
    let maxHeaderHeight: CGFloat = 192 - UIApplication.topSafeAreaHeight
    let minHeaderHeight: CGFloat = 56.0
    var previousScrollOffset: CGFloat = 0.0
//    var toDoData = [Task]()
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        toDoView?.heightNavigationView?.update(offset: maxHeaderHeight)
        self.updateHeader()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: Initialize
    private func initView() {
        toDoView = ToDoView(frame: self.view.frame)
        toDoView?.tableView.delegate = self
        toDoView?.tableView.dataSource = self
        self.view.addSubview(toDoView ?? UIView())
        toDoView?.tableView.register(cellWithClass: ToDoCell.self)
    }
    
    // MARK: Animation Header
    func isPossibleToAnimate(withHeader scrollView: UIScrollView) -> Bool {
        guard let heightNavigationView = toDoView?.heightNavigationView?.layoutConstraints[0].constant else { return false }
        let scrollViewMaxHeight = scrollView.frame.height + heightNavigationView - minHeaderHeight
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func scrollViewDidStopScrolling() {
        guard let heightNavigationView = toDoView?.heightNavigationView?.layoutConstraints[0].constant else { return }
        let range = maxHeaderHeight - minHeaderHeight
        let midPoint = minHeaderHeight + range / 2
        animateHeader(heightNavigationView > midPoint)
    }

    private func animateHeader(_ isExpanding: Bool) {
        view.layoutIfNeeded()
        if isExpanding {
            UIView.animate(withDuration: 0.3, animations: {
                self.toDoView?.heightNavigationView?.update(offset: self.maxHeaderHeight)
                self.updateHeader()
                self.view.layoutIfNeeded()
            })
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.toDoView?.heightNavigationView?.update(offset: self.minHeaderHeight)
                self.updateHeader()
                self.view.layoutIfNeeded()
            })
        }
    }

    func updateHeader() {
        guard let heightNavigationView = toDoView?.heightNavigationView?.layoutConstraints[0].constant else { return }
        let range = maxHeaderHeight - minHeaderHeight
        let openAmount: CGFloat = heightNavigationView - minHeaderHeight
        let percentage: CGFloat = openAmount / range
        let fontSize: CGFloat = (14 * percentage) + 18
        toDoView?.titleLabel.font = UIFont.systemFont(ofSize: fontSize)
        toDoView?.navigationImageViewBottom?.update(offset: 88 * (1.0 - percentage))
    }
}
