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
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        initView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // MARK: Initialize
    private func initView() {
        toDoView = ToDoView(frame: self.view.frame)
        toDoView?.tableview.delegate = self
        toDoView?.tableview.dataSource = self
        self.view.addSubview(toDoView ?? UIView())
    }    
}
