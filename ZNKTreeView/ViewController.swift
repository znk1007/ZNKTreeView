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
        $0.separatorInset = .zero
        $0.register(TreeViewCell.self, forCellReuseIdentifier: TreeViewCell.Setting.identifier)
        return $0
    }(ZNKTreeView.init(frame: view.bounds, style: .grouped))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(treeView)
        TreeObject.initTest { [weak self] (objects) in
            self?.dataSource = objects
            self?.treeView.reloadData()
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ZNKTreeViewDelete {



    func treeView(_ treeView: ZNKTreeView, didSelect item: ZNKTreeItem?) {
        if let item = item as? TreeObject {
            print("level ====> ", treeView.levelFor(item))
            print("indexPath ---> ", treeView.indexPathFor(item) as Any)
            print("item identifier ---> ", item.identifier)
            print("item name ---> ", item.name)
        }
    }

    func treeView(_ treeView: ZNKTreeView, heightfor item: ZNKTreeItem?) -> CGFloat {
        return 50
    }

}

extension ViewController: ZNKTreeViewDataSource {



    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int {
        return dataSource.count
    }

    func treeView(_ treeView: ZNKTreeView, numberOfChildrenFor item: ZNKTreeItem?, at index: Int) -> Int {
        if let item = item as? TreeObject {
            return item.children.count
        } else {
            return dataSource[index].children.count
        }
    }

    func treeView(_ treeView: ZNKTreeView, childIndex child: Int, ofItem item: ZNKTreeItem?, at rootIndex: Int) -> ZNKTreeItem? {
        if let item = item as? TreeObject {
            return item.children[child]
        } else {
            return dataSource[rootIndex]
        }
    }

    func treeView(_ treeView: ZNKTreeView, cellFor item: ZNKTreeItem?, at indexPath: IndexPath) -> UITableViewCell {
        var cell = treeView.dequeueReusableCell(TreeViewCell.Setting.identifier) as? TreeViewCell
        if cell == nil {
            cell = TreeViewCell.init(style: .default, reuseIdentifier: TreeViewCell.Setting.identifier)
        }
        guard let c = cell else { return .init() }
        if let item = item as? TreeObject {
            let level = treeView.levelFor(item, at: indexPath)
            c.updateTreeCell(item, level: level)
        }
        return c
    }

}

