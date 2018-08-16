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
    
}

extension ViewController: TreeViewDataSource {

    func treeView(_ treeView: TreeView, viewForHeaderForRoot root: Any) -> UIView? {
        if let item = root as? TreeItem {
            var headerView = treeView.dequeueReusableHeaderFooterView(TreeViewHeaderView.Setting.identifier) as? TreeViewHeaderView
            if headerView == nil {
                headerView = .init()
            }
            headerView?.updateHeader(item.name, completion: { [weak self] (expand) in
                print("is expand ---> ", expand)
            })
            return headerView
        }
        return nil
    }

    func treeView(_ treeView: TreeView, cellFor item: Any) -> UITableViewCell {
        var cell = treeView.dequeueReusableCell(<#T##cellIdentifier: String##String#>, forItemIdentifier: <#T##String#>, at: <#T##IndexPath#>)

        return .init()
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
            let childItem = item.children[childIndex]
            return (childItem, childItem.identifier)
        } else {
            let childItem = treeItems[rootIndex]
            return (childItem, childItem.identifier)
        }
    }

}
