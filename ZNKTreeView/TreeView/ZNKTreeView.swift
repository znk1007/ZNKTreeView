//
//  ZNKTreeView.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class ZNKTreeView: UIView {

    //MARK: ******Public*********

    /// 代理
    var delegate: ZNKTreeViewDelete?
    /// 数据源
    var dataSource: ZNKTreeViewDataSource?

    /// 预估行高 默认0
    var estimatedRowHeight: CGFloat = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.estimatedRowHeight = estimatedRowHeight
        }
    }

    /// 预估段尾高度 默认0
    var estimatedSectionFooterHeight: CGFloat = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        }
    }
    /// 预估段头高度 默认0
    var estimatedSectionHeaderHeight: CGFloat = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
        }
    }

    /// 背景视图
    var backgroundView: UIView? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.backgroundView = backgroundView
        }
    }


    //MARK: ******Private*********
    /// 表格
    private var treeTable: UITableView!

    /// 树形图展示类型
    ///
    /// - grouped: 分组
    /// - plain: 平铺
    enum TreeViewStyle {
        case grouped
        case plain
    }

    /// 显示类型
    private var style: TreeViewStyle {
        didSet {
            switch style {
            case .plain:
                tableStyle = .plain
            case .grouped:
                tableStyle = .grouped
            }
        }
    }

    /// 表格类型
    private var tableStyle: UITableViewStyle = .plain

    /// 节点管理
    private var manager: ZNKTreeNodeController = .init()

    /// 批量处理对象
    private var batchChanges: ZNKBatchChanges = .init()
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 坐标及大小
    ///   - style: 类型
    init(frame: CGRect, style: TreeViewStyle) {
        self.style = style
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        self.style = .plain
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /// 初始化
    private func commonInit() {
        initSubview()
        initConfiguration()
    }

    /// 初始化视图
    private func initSubview() {
        self.treeTable = UITableView.init(frame: bounds, style: tableStyle)
        treeTable.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        treeTable.estimatedRowHeight = 0
        treeTable.estimatedSectionHeaderHeight = 0
        treeTable.estimatedSectionFooterHeight = 0
        treeTable.dataSource = self
        treeTable.delegate = self
        self.addSubview(treeTable)
    }

    /// 初始化配置
    private func initConfiguration() {
        manager.delegate = self
    }
}


extension ZNKTreeView: UITableViewDelegate {

}

extension ZNKTreeView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfRootItemInTreeView(self) ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }


}

extension ZNKTreeView: ZNKTreeNodeControllerDelegate {

//    func rootNotes() -> [ZNKTreeNode] {
//        let items = dataSource?.rootItemsInTreeView(self) ?? []
//        let nodes = items.map({ZNKTreeNode.init($0, parent: nil, indexPath: $0.indexPath, expandHandler: { (_) -> Bool in
//            return true
//        })})
//        return nodes
//    }

    func numberOfChildrenForNote(_ item: ZNKTreeNode?) -> Int {
        return 0
    }


//    func rootNotes() -> [ZNKTreeNode] {
//        let items = dataSource?.rootItemsInTreeView(self) ?? []
//        let nodes = items.map({ZNKTreeNode.init($0, parent: nil, indexPath: $0.indexPath, expandHandler: { (_) -> Bool in
//            return true
//        })})
//        return nodes
//    }
//
//    func numberOfChildrenForItem(_ item: ZNKTreeItem?) -> Int {
//        return dataSource?.treeView(self, numberOfChildrenForItem: item) ?? 0
//    }



}
