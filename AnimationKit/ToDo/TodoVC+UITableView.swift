//
//  TodoVC+UITableView.swift
//  AnimationKit
//
//  Created by Ferdinand on 22/12/21.
//

import UIKit
import SnapKit

// MARK: UITableView Delegate
extension ToDoVC: UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let scrollDiff = scrollView.contentOffset.y - previousScrollOffset

        let absoluteTop: CGFloat = 0.0
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isReachingTop = scrollView.contentOffset.y <= absoluteTop

        guard isPossibleToAnimate(withHeader: scrollView) else { return }

        guard let heightNavigationView = toDoView?.heightNavigationView?.layoutConstraints[0].constant else { return }
        var newHeight: CGFloat = heightNavigationView
        if isScrollingDown {
            newHeight = max(minHeaderHeight, heightNavigationView - abs(scrollDiff))
        } else if isReachingTop {
            newHeight = min(maxHeaderHeight, heightNavigationView + abs(scrollDiff))
        }

        if newHeight != heightNavigationView {
            toDoView?.heightNavigationView?.update(offset: newHeight)
            updateHeader()
            toDoView?.tableView.contentOffset = CGPoint(x: (toDoView?.tableView.contentOffset.x)!, y: previousScrollOffset)
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
        return 100
    }
    /*
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toDoData.count == 0 {
            toDoEmptyView = ToDoEmptyView(frame: tableView.frame)
            self.toDoView?.tableView.backgroundView = toDoEmptyView
            return 0
        } else {
            self.toDoView?.tableView.backgroundView = nil
            return toDoData.count
        }
    }
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell1", for: indexPath)
        cell.textLabel?.text = "Hello World cell: \(indexPath.row)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
    }
}
