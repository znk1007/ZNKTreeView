//
//  TreeView.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/11.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class TreeView: UIView {

    /// 树形图数据源代理
    var dataSource: TreeViewDataSource?

    /// 树形图代理
    var delegate: TreeViewDelegate?

    /// 是否展开所有元素
    var expandAll: Bool = false
    /// 是否记录单元格展开状态
    var holdExpandState: Bool = false

    /// 预计行高
    var estimatedRowHeight: CGFloat = 0 {
        didSet {
            guard let table = tableView else { return }
            table.estimatedRowHeight = estimatedRowHeight
        }
    }

    /// 预计段尾高度
    var estimatedSectionFooterHeight: CGFloat = 0 {
        didSet {
            guard let table = tableView else { return }
            table.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        }
    }

    /// 预计段头高度
    var estimatedSectionHeaderHeight: CGFloat = 0 {
        didSet {
            guard let table = tableView else { return }
            table.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
        }
    }

    /// 分割线内嵌
    var separatorInset: UIEdgeInsets = .zero {
        didSet {
            guard let table = tableView else { return }
            table.separatorInset = separatorInset
        }
    }

    /// 背景视图
    var backgroundView: UIView? = nil {
        didSet {
            guard let table = tableView else { return }
            table.backgroundView = backgroundView
        }
    }

    /// 树形图行高
    var rowHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            guard let table = tableView else { return }
            table.rowHeight = rowHeight
        }
    }

    /// 表格视图风格
    private var tableViewStyle: UITableViewStyle
    /// 表格
    private var tableView: UITableView?

    /// 节点管理器
    private var controller: TreeNodeController?

    /// 初始化树形图
    ///
    /// - Parameters:
    ///   - frame: 边框
    ///   - style: 风格
    init(frame: CGRect, style: TreeViewStyle) {
        self.tableViewStyle = style.style
        super.init(frame: frame)
        initController()
        initSubview()
        defaultConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 子视图
    private func initSubview() {
        tableView = UITableView.init(frame: .zero, style: tableViewStyle)
        tableView?.dataSource = self
        tableView?.delegate = self
        addSubview(tableView!)
    }

    /// 初始化管理器
    private func initController() {
        controller = TreeNodeController.init()
        controller?.dataSource = self
    }

    /// 默认配置
    private func defaultConfiguration() {
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView?.frame = self.bounds
    }
}

// MARK: - 公共方法
extension TreeView {
    /// 刷新数据
    func reloadData() {
        guard let table = tableView, let controller = controller else { return }
        controller.loadTreeNodes()
        table.reloadData()
    }

    /// 注册树形图单元格
    ///
    /// - Parameters:
    ///   - cellClass: 单元格类
    ///   - identifier: 复用唯一标识
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String) {
        guard let table = tableView else { return }
        table.register(cellClass, forCellReuseIdentifier: identifier)
    }

    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        guard let table = tableView else { return }
        table.register(nib, forCellReuseIdentifier: identifier)
    }

    /// 注册段头段尾视图
    ///
    /// - Parameters:
    ///   - aClass: 视图类
    ///   - forHeaderFooterViewReuseIdentifier: 复用唯一标识
    func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        guard let table = tableView else { return }
        table.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// 注册段头段尾视图
    ///
    /// - Parameters:
    ///   - nib: UINib
    ///   - identifier: 唯一标识
    func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        guard let table = tableView else { return }
        table.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// 复用单元格
    ///
    /// - Parameter identifier: 唯一标识
    func dequeueReusableCell(_ identifier: String) -> UITableViewCell {
        guard let table = tableView else { return .init() }
        return table.dequeueReusableCell(withIdentifier: identifier) ?? .init()
    }

    /// 复用单元格
    ///
    /// - Parameters:
    ///   - cellIdentifier: 单元格唯一标识
    ///   - item: 元素
    ///   - identifier: 元素唯一标识
    ///   - indexPath: 地址索引
    func dequeueReusableCell(_ cellIdentifier: String, at indexPath: IndexPath) -> UITableViewCell {
        guard let table = tableView, let node = controller?.treeNodeFor(indexPath) else { return .init() }
        return table.dequeueReusableCell(withIdentifier: cellIdentifier, for: node.indexPath)
    }

    /// 复用段头段尾视图
    ///
    /// - Parameter identifier: 唯一标识
    /// - Returns: 段头段尾视图
    func dequeueReusableHeaderFooterView(_ identifier: String) -> UITableViewHeaderFooterView? {
        guard let table = tableView else { return nil }
        return table.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    /// 指定地址索引的层级
    ///
    /// - Parameter indexPath: 地址索引
    /// - Returns: 层级
    func levelFor(_ indexPath: IndexPath) -> Int {
        guard let node = controller?.treeNodeFor(indexPath) else { return -1 }
        return node.level
    }

}

// MARK: - 表格数据源代理
extension TreeView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfRootItem(in: self) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controller?.numberOfVisibleNodeIn(section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let node = controller?.treeNodeFor(indexPath), let cell = dataSource?.treeView(self, cellFor: node.object, at: indexPath) {
            return cell
        }
        return .init()
    }
}


// MARK: - 表格视图代理
extension TreeView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let rootNode = controller?.rootNodeFor(section) else { return nil }
        return dataSource?.treeView(self, viewForHeaderForRoot: rootNode.object)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let rootNode = controller?.rootNodeFor(section) else { return nil }
        return dataSource?.treeView(self, viewForFooterForRoot: rootNode.object)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let node = controller?.treeNodeFor(indexPath) {
            return delegate?.treeView(self, heightFor: node.object, at: indexPath) ?? 50
        }
        return 50
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return delegate?.treeView(self, heightForHeaderIn: section) ?? 50
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return delegate?.treeView(self, heightForFooterIn: section) ?? 50
    }
}

// MARK: - 管理器数据源代理
extension TreeView: TreeNodeControllerDataSource {
    var numberOfRootNode: Int {
        return dataSource?.numberOfRootItem(in: self) ?? 0
    }

    func numberOfChildren(for node: TreeNode?, in rootIndex: Int) -> Int {
        return dataSource?.treeView(self, numberOfChildFor: node?.object, In: rootIndex) ?? 0
    }

    func treeNode(at childIndex: Int, of node: TreeNode?, in rootIndex: Int) -> TreeNode? {
        if let item = dataSource?.treeView(self, childIndex: childIndex, for: node?.object, in: rootIndex) {
            return TreeNode.init(object: item, isExpand: expandAll, parent: node)
        }
        return nil
    }

    
}
