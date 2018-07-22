//
//  ViewController.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/7/19.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private var dataSource: [TreeObject] = []

    private lazy var treeView: ZNKTreeView = {
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(ZNKTreeView.init(frame: view.bounds, style: .plain))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(treeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ZNKTreeViewDelete {

}

extension ViewController: ZNKTreeViewDataSource {

    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int {
        return dataSource.count
    }

    func treeView(_ treeView: ZNKTreeView, numberOfChildrenForItem item: ZNKTreeItem?, atRootItemIndex index: Int) -> Int {
        if let item = item as? TreeObject {
            return item.children.count
        } else {
            return dataSource[index].children.count
        }
    }

    func treeView(_ treeView: ZNKTreeView, childIndex child: Int, ofItem item: ZNKTreeItem?, atRootIndex root: Int) -> ZNKTreeItem? {
        if let item = item as? TreeObject {
            return item.children[child]
        } else {
            return dataSource[root]
        }
    }

}

