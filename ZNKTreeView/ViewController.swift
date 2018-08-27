//
//  ViewController.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/11.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    /// 树形图视图
    private lazy var treeView: TreeView = {
        $0.delegate = self
        $0.dataSource = self
        $0.expandAll = true
        $0.separatorInset = .zero
        $0.register(TreeViewCell.self, forCellReuseIdentifier: TreeViewCell.Setting.identifier)
        $0.register(TreeViewHeaderView.self, forHeaderFooterViewReuseIdentifier: TreeViewHeaderView.Setting.identifier)
        return $0
    }(TreeView.init(frame: self.view.bounds, style: .grouped))

    /// 数据源
    private var treeItems: [TreeItem] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(treeView)
        TreeItem.fetchData { [weak self] (items) in
            if let weakSelf = self {
                weakSelf.treeItems = items
                weakSelf.treeView.reloadData()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            self.treeView.moveItem(IndexPath.init(row: 0, section: 1), to: IndexPath.init(row: 0, section: 0))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        treeView.frame = view.bounds
    }

}

extension ViewController: TreeViewDelegate {

    func treeView(_ treeView: TreeView, heightFor item: Any?) -> CGFloat {
        return 48
    }

    func treeView(_ treeView: TreeView, heightForHeaderIn rootIndex: Int) -> CGFloat {
        return 48
    }

    func treeView(_ treeView: TreeView, heightForFooterIn rootIndex: Int) -> CGFloat {
        return 0.001
    }


    func treeView(_ treeView: TreeView, didSelect item: Any, at indexPath: IndexPath) {
        if let item = item as? TreeItem {
            print("item name ==> ", item.name)
        }
    }

    func treeView(_ treeView: TreeView, willExpand item: Any, at indexPath: IndexPath) {
        if let item = item as? TreeItem {
            print("will expand item name ==> ", item.name)
        }
    }

    func treeView(_ treeView: TreeView, didExpand item: Any, at indexPath: IndexPath) {
        if let item = item as? TreeItem {
            print("did expand item name ==> ", item.name)
        }
    }

    func treeView(_ treeView: TreeView, willShrink item: Any, at indexPath: IndexPath) {
        if let item = item as? TreeItem {
            print("will shrink item name ==> ", item.name)
        }
    }

    func treeView(_ treeView: TreeView, didShrink item: Any, at indexPath: IndexPath) {
        if let item = item as? TreeItem {
            print("did shrink item name ==> ", item.name)
        }
    }

}

extension ViewController: TreeViewDataSource {

    func treeView(_ treeView: TreeView, viewForHeaderForRoot root: Any, in rootIndex: Int) -> UIView? {
        if let item = root as? TreeItem {
            var headerView = treeView.dequeueReusableHeaderFooterView(TreeViewHeaderView.Setting.identifier) as? TreeViewHeaderView
            if headerView == nil {
                headerView = .init()
            }
            let indexPath = IndexPath.init(row: -1, section: rootIndex)

            headerView?.updateHeader(item.name, completion: { [weak self] (expand) in
                print("is expand ---> ", expand)
                treeView.updateExpandShrink(at: indexPath, expandOrShrinkChildren: true)

            })
            return headerView
        }
        return nil
    }

    func treeView(_ treeView: TreeView, cellFor item: Any, at indexPath: IndexPath) -> UITableViewCell {
        var cell = treeView.dequeueReusableCell(TreeViewCell.Setting.identifier) as? TreeViewCell
        if cell == nil {
            cell = TreeViewCell.init(style: .default, reuseIdentifier: TreeViewCell.Setting.identifier)
        }
        guard let c = cell, let item = item as? TreeItem else { return .init() }
        c.updateCell(item.name, level: treeView.levelFor(indexPath))
        return c
    }

    func numberOfRootItem(in treeView: TreeView) -> Int {
        return treeItems.count
    }

    func treeView(_ treeView: TreeView, numberOfChildFor item: Any?, In rootIndex: Int) -> Int {
        if let item = item as? TreeItem {
            return item.children.count
        } else {
            return treeItems[rootIndex].children.count
        }
    }

    func treeView(_ treeView: TreeView, childIndex: Int, for item: Any?, in rootIndex: Int) -> (Any?, String?) {
        if let item = item as? TreeItem {
            let child = item.children[childIndex]
            return (child, child.identifier)
        } else {
            let child = treeItems[rootIndex]
            return (child, child.identifier)
        }
    }

}
