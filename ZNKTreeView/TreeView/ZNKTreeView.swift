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

    deinit {
        treeTable.delegate = nil
        treeTable.dataSource = nil
        treeTable = nil
    }

    /// 初始化
    private func commonInit() {
        if treeTable == nil {
            initTable()
        }
        initConfiguration()
    }


    /// 初始化视图
    private func initTable() {
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
//MARK: ************ public methods ******************
extension ZNKTreeView {

    /// 注册UITableViewCell类
    ///
    /// - Parameters:
    ///   - cellClass: UITableViewCell类
    ///   - identifier: 唯一标识
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)  {
        guard let table = treeTable else { return }
        table.register(cellClass, forCellReuseIdentifier: identifier)
    }

    /// 注册UITableViewCell的UINib
    ///
    /// - Parameters:
    ///   - nib: UINib
    ///   - identifier: 唯一标识
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        guard let table = treeTable else { return }
        table.register(nib, forCellReuseIdentifier: identifier)

    }

    /// 注册UITableView头部类
    ///
    /// - Parameters:
    ///   - aClass: 头部视图类
    ///   - identifier: 唯一标识
    func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        guard let table = treeTable else { return }
        table.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// 注册UITableView头部UINib
    ///
    /// - Parameters:
    ///   - nib: UINib
    ///   - identifier: 唯一标识
    func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        guard let table = treeTable else { return }
        table.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// 复用UITableViewCell
    ///
    /// - Parameter identifier: 唯一标识
    /// - Returns: UITableViewCell 可能为nil
    func dequeueReusableCell(_ identifier: String) -> UITableViewCell? {
        guard let table = treeTable else { return nil }
        return table.dequeueReusableCell(withIdentifier: identifier)
    }

    /// 复用UITableViewCell
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识
    ///   - indexPath: 地址索引
    /// - Returns: UITableViewCell
    func dequeueReusableCell(_ identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        guard let table = treeTable else { return .init() }
        return table.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    /// 复用段头段尾
    ///
    /// - Parameter identifier: 唯一标识
    /// - Returns: UITableViewHeaderFooterView?
    func dequeueReusableHeaderFooterView(_ identifier: String) -> UITableViewHeaderFooterView? {
        guard let table = treeTable else { return nil }
        return table.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    /// 刷新表格
    func reloadData() {
        guard let table = treeTable else { return }
        table.reloadData()
    }
}


extension ZNKTreeView: UITableViewDelegate {

}

extension ZNKTreeView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfRootItemInTreeView(self) ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        manager.visibleNodes()
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return .init()
    }


}

extension ZNKTreeView: ZNKTreeNodeControllerDelegate {

    func numberOfRootNode() -> Int {
        return dataSource?.numberOfRootItemInTreeView(self) ?? 0
    }

    func numberOfChildrenForNode(_ node: ZNKTreeNode?, atRootIndex index: Int) -> Int {
        return dataSource?.treeView(self, numberOfChildrenForItem: node?.item, atRootItemIndex: index) ?? 0
    }

    func treeNode(at childIndex: Int, of node: ZNKTreeNode?, atRootIndex index: Int) -> ZNKTreeNode? {
        if let item = dataSource?.treeView(self, childIndex: childIndex, ofItem: node?.item, atRootIndex: index) {
            return ZNKTreeNode.init(item: item, parent: node, indexPath: IndexPath.init(row: childIndex, section: index))
        } else {
            return nil
        }
    }

}
