//
//  ToDoVC.swift
//  AnimationKit
//
//  Created by Ferdinand on 21/12/21.
//

import UIKit
import SnapKit

struct Task: Codable {
    let titleTask: String
    let subtitleTask: String
}

class ToDoVC: UIViewController {

    var toDoView: ToDoView?
    var toDoEmptyView: ToDoEmptyView?
    var toDoData = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        initView()
    }
    
    private func initView() {
        toDoView = ToDoView(frame: self.view.frame)
        toDoView?.tableview.delegate = self
        toDoView?.tableview.dataSource = self
        self.view.addSubview(toDoView ?? UIView())
        toDoView?.addButton.addTarget(self, action: #selector(addTask(_:)), for: .touchUpInside)
    }
    
    @objc func addTask(_ sender: UIButton) {
        
    }
}
