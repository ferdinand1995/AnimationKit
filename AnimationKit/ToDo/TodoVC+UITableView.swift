//
//  TodoVC+UITableView.swift
//  AnimationKit
//
//  Created by Ferdinand on 22/12/21.
//

import UIKit

// MARK: UITableView Delegate
extension ToDoVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if toDoData.count == 0 {
            toDoEmptyView = ToDoEmptyView(frame: tableView.frame)
            self.toDoView?.tableview.backgroundView = toDoEmptyView
            return 0
        } else {
            self.toDoView?.tableview.backgroundView = nil
            return toDoData.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
