//
//  TreeView.swift
//  TreeView
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

    /// 分割风格
    var separatorStyle: TreeViewCellSeperatorStyle = .none {
        didSet {
            guard let table = tableView else { return }
            table.separatorStyle = separatorStyle.style
        }
    }

    /// 分割颜色
    var separatorColor: UIColor? = nil {
        didSet {
            guard let table = tableView else { return }
            table.separatorColor = separatorColor
        }
    }

    /// 调整右侧像素
    var cellLayoutMarginsFollowReadableWidth: Bool = false {
        didSet {
            guard let table = tableView else { return }
            table.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        }
    }

    /// 分割效果
    var seperatorEffect: UIVisualEffect? {
        didSet {
            guard let table = tableView else { return }
            table.separatorEffect = seperatorEffect
        }
    }
    // 段头高度 默认 UITableViewAutomaticDimension
    var sectionHeaderHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            guard let table = tableView else { return }
            table.sectionHeaderHeight = sectionHeaderHeight
        }
    }
    // 段尾高度 默认 UITableViewAutomaticDimension
    var sectionFooterHeight: CGFloat = UITableViewAutomaticDimension{
        didSet {
            guard let table = tableView else { return }
            table.sectionFooterHeight = sectionFooterHeight
        }
    }

    /// 元素是否在编辑状态
    var isItemEditing: Bool {
        set {
            guard let table = tableView else { return }
            table.isEditing = newValue
        }
        get {
            guard let table = tableView else { return false }
            return table.isEditing
        }
    }

    /// 非编辑状态下是否可选
    var allowsItemSelection: Bool {
        set {
            guard let table = tableView else { return }
            table.allowsSelection = allowsItemSelection
        }
        get {
            guard let table = tableView else { return false }
            return table.allowsSelection
        }
    }

    /// 编辑状态下是否可选
    var allowsItemSelectionDuringEditing: Bool {
        set {
            guard let table = tableView else { return }
            table.allowsSelectionDuringEditing = allowsItemSelectionDuringEditing
        }
        get {
            guard let table = tableView else { return false }
            return table.allowsSelectionDuringEditing
        }
    }


    /// 是否允许多选
    var allowsMultipleItemSelection: Bool {
        set {
            guard let table = tableView else { return }
            table.allowsMultipleSelection = allowsMultipleItemSelection
        }
        get {
            guard let table = tableView else { return false }
            return table.allowsMultipleSelection
        }
    }

    /// 编辑状态下是否可以多选
    var allowsMultipleItemSelectionDuringEditing: Bool {
        get {
            guard let table = tableView else { return false }
            return table.allowsMultipleSelectionDuringEditing
        }
        set {
            guard let table = tableView else { return }
            table.allowsMultipleSelectionDuringEditing = allowsMultipleItemSelectionDuringEditing
        }
    }

    /// 选中元素的地址索引
    var indexPathForSelectedItem: IndexPath? {
        guard let table = tableView else { return nil }
        return table.indexPathForSelectedRow
    }
    /// 选中元素的地址索引数组
    var indexPathsForSelectedItems: [IndexPath]? {
        guard let table = tableView else { return nil }
        return table.indexPathsForVisibleRows

    }

    /// 每段最少显示元素数
    var sectionIndexMinimumDisplayItemCount: Int = 0 {
        didSet {
            guard let table = tableView else { return }
            table.sectionIndexMinimumDisplayRowCount = sectionIndexMinimumDisplayItemCount
        }
    }

    /// 段下标颜色
    var sectionIndexColor: UIColor? = nil {
        didSet {
            guard let table = tableView else { return }
            table.sectionIndexColor = sectionIndexColor
        }
    }

    /// 段下标背景颜色
    var sectionIndexBackgroundColor: UIColor? = nil {
        didSet {
            guard let table = tableView else { return }
            table.sectionIndexBackgroundColor = sectionIndexBackgroundColor
        }
    }

    /// /// 段下标轨迹背景颜色
    var sectionIndexTrackingBackgroundColor: UIColor? = nil {
        didSet {
            guard let table = tableView else { return }
            table.sectionIndexTrackingBackgroundColor = sectionIndexTrackingBackgroundColor
        }
    }

    /// 内容视图嵌入安全域
    var insetsContentViewsToSafeArea: Bool = true {
        didSet {
            guard let table = tableView else { return }
            if #available(iOS 11.0, *) {
                table.insetsContentViewsToSafeArea = insetsContentViewsToSafeArea
            } else {
                // Fallback on earlier versions
            }
        }
    }

    /// 树形图头部视图
    var treeHeaderView: UIView? = nil {
        didSet {
            guard let table = tableView else { return }
            table.tableHeaderView = treeHeaderView
        }
    }

    /// 树形图尾部视图
    var treeFooterView: UIView? = nil {
        didSet {
            guard let table = tableView else { return }
            table.tableFooterView = treeFooterView
        }
    }

    /// 记住最后选中的元素
    var remembersLastFocusedItem: Bool = false {
        didSet {
            guard let table = tableView else { return }
            table.remembersLastFocusedIndexPath = remembersLastFocusedItem
        }
    }

    /// 是否允许拖拽
    var dragInteractionEnabled: Bool = false {
        didSet {
            guard let table = tableView else { return }
            if #available(iOS 11.0, *) {
                table.dragInteractionEnabled = dragInteractionEnabled
            } else {
                // Fallback on earlier versions
            }
        }
    }

    /// 是否激活拖拽
    var hasActiveDrag: Bool {
        get {
            guard let table = tableView else { return false }
            if #available(iOS 11.0, *) {
                return table.hasActiveDrag
            } else {
                // Fallback on earlier versions
                return false
            }
        }
    }

    /// 根元素数
    var numberOfRootItems: Int {
        guard let table = tableView else { return 0 }
        return table.numberOfSections
    }

    /// 展开元素时，是否同时展开所有子元素，默认false
    var expandChildrenWhenItemExpand: Bool = false

    /// 展开元素动画模式 默认none
    var expandAnimation: TreeViewRowAnimation = .none

    /// 收缩元素时，是否同时收缩所有子元素，默认false
    var shrinkChildrenWhenItemShrink: Bool = false

    /// 收缩动画模式，默认none
    var shrinkAnimation: TreeViewRowAnimation = .none

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

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView?.frame = self.bounds
    }
}


// MARK: - 私有方法
extension TreeView {
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

    /// 展开指定节点
    ///
    /// - Parameters:
    ///   - node: 指定节点
    ///   - expand: 是否展开所有子节点
    private func expandNode(_ node: TreeNode, indexPath: IndexPath) {
        guard let controller = controller, let rootNode = controller.rootNodeFor(node.indexPath.section) else { return }

        if let dataSource = dataSource, dataSource.treeView(self, canExpand: node.object) == false {
            return
        }

        if node.isExpand == true || node.children.count == 0 {
            return
        }

        if let delegate = delegate {
            delegate.treeView(self, willExpand: node.object, at: indexPath)
        }

        node.isExpand = true
        var nodeIndex = node.indexPath.row
        var indexPaths: [IndexPath] = []
        node.expandVisibleChildIndexPath(&nodeIndex, indexPaths: &indexPaths)
        rootNode.resetAllIndexPath()
        let _ = indexPaths.map({print("expand indexPaths --> \($0)")})
        if expandChildrenWhenItemExpand {
            node.updateExpand(true)
        }


        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.async {
                self.delegate?.treeView(self, didExpand: node.object, at: indexPath)
            }
        }
        batchUpdates(.insertion, indexPaths: indexPaths, animation: expandAnimation)
        CATransaction.commit()
    }

    /// 收缩折叠指定节点
    ///
    /// - Parameters:
    ///   - node: 指定节点
    ///   - shrink: 是否折叠所有子节点
    private func shrinkNode(_ node: TreeNode, indexPath: IndexPath) {
        guard let controller = controller, let rootNode = controller.rootNodeFor(node.indexPath.section) else { return }

        if let dataSource = dataSource, dataSource.treeView(self, canShrink: node.object) == false {
            return
        }

        if node.isExpand == false || node.children.count == 0{
            return
        }
        if let delegate = delegate {
            delegate.treeView(self, willShrink: node.object, at: indexPath)
        }
        var indexPaths: [IndexPath] = []
        node.shrinkVisibleChildIndexPath(&indexPaths)
        rootNode.resetAllIndexPath()
        node.isExpand = false
        if shrinkChildrenWhenItemShrink {
            node.updateExpand(false)
        }
        let _ = indexPaths.map({print("shrink indexPaths --> \($0)")})
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            DispatchQueue.main.async {
                if let delegate = self.delegate {
                    delegate.treeView(self, didShrink: node.object, at: indexPath)
                }
            }
        }
        batchUpdates(.deletion, indexPaths: indexPaths, animation: shrinkAnimation)
        CATransaction.commit()
    }

    /// 批量更新
    ///
    /// - Parameters:
    ///   - type: 更新类型
    ///   - indexPaths: 地址索引数组
    private func batchUpdates(_ type: BatchUpdates, indexPaths: [IndexPath], animation: TreeViewRowAnimation = .none) {
        guard let table = tableView, indexPaths.count > 0 else { return }
        if #available(iOS 11.0, *) {
            table.performBatchUpdates({
                switch type {
                case .insertion:
                    table.insertRows(at: indexPaths, with: animation.animation)
                case .deletion:
                    table.deleteRows(at: indexPaths, with: animation.animation)
                case .update:
                    table.reloadRows(at: indexPaths, with: animation.animation)
                }
            }, completion: nil)
        } else {
            table.beginUpdates()
            switch type {
            case .insertion:
                table.insertRows(at: indexPaths, with: animation.animation)
            case .deletion:
                table.deleteRows(at: indexPaths, with: animation.animation)
            case .update:
                table.reloadRows(at: indexPaths, with: animation.animation)
            }
            table.endUpdates()
        }
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

    /// 展开指定地址索引的元素
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - expandChildren: 是否展开子元素
    ///   - animation: 展开动画
    func expandItem(at indexPath: IndexPath, expandChildren: Bool = false, animation: TreeViewRowAnimation = .none)  {
        guard let _ = tableView, let controller = controller else { return }
        expandChildrenWhenItemExpand = expandChildren
        expandAnimation = animation
        if indexPath.row < 0 {
            /// 根节点
            if let rootNode = controller.rootNodeFor(indexPath.section) {
                expandNode(rootNode, indexPath: indexPath)
            }
        } else {
            if let node = controller.treeNodeFor(indexPath) {
                expandNode(node, indexPath: indexPath)
            }
        }
    }

    /// 展开指定地址索引的元素
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - expandChildren: 是否展开子元素
    ///   - animation: 展开动画
    func shrinkItem(at indexPath: IndexPath, shrinkChildren: Bool = false, animation: TreeViewRowAnimation = .none)  {
        guard let _ = tableView, let controller = controller else { return }
        shrinkChildrenWhenItemShrink = shrinkChildren
        shrinkAnimation = animation
        if indexPath.row < 0 {
            /// 根节点
            if let rootNode = controller.rootNodeFor(indexPath.section) {
                shrinkNode(rootNode, indexPath: indexPath)
            }
        } else {
            if let node = controller.treeNodeFor(indexPath) {
                shrinkNode(node, indexPath: indexPath)
            }
        }
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
        return dataSource?.treeView(self, viewForHeaderForRoot: rootNode.object, in: section)
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let rootNode = controller?.rootNodeFor(section) else { return nil }
        return dataSource?.treeView(self, viewForFooterForRoot: rootNode.object, in: section)
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let node = controller?.treeNodeFor(indexPath) else { return }
        if let delegate = delegate {
            delegate.treeView(self, didSelect: node.object, at: indexPath)
        }
        if node.children.count == 0 {
            return
        }
        if node.isExpand {
            shrinkNode(node, indexPath: indexPath)
        } else {
            expandNode(node, indexPath: indexPath)
        }
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
