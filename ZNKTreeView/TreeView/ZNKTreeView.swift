//
//  ZNKTreeView.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit
//MARK: ************************** ZNKTreeItem ***********************
class ZNKTreeItem {
    let identifier: String
    var expand: Bool
    init(identifier: String, expand: Bool) {
        self.identifier = identifier
        self.expand = expand
    }
}


//MARK: ************************** ZNKBatchChangeObject ***********************
/// 批量处理对象
fileprivate class ZNKBatchChangeObject {
    /// 批量改变类型
    ///
    /// - insertion: 插入
    /// - expansion: 展开
    /// - deletion: 删除
    /// - collapse: 收起
    /// - move: 移动
    enum ZNKBatchChangeType {
        case insertion
        case expansion
        case deletion
        case collapse
        case move
    }

    /// 处理类型
    let type: ZNKBatchChangeType
    /// 排序
    let ranking: IndexPath
    /// 更新回调
    let updates:(() -> ())
    init(_ type: ZNKBatchChangeType, ranking: IndexPath, updates: @escaping (() -> ())) {
        self.type = type
        self.ranking = ranking
        self.updates = updates
    }

    /// 比较两个批量处理实例对象
    ///
    /// - Parameter other: 比较源对象
    /// - Returns: ComparisonResult
    func compare(_ other: ZNKBatchChangeObject) -> ComparisonResult {
        if self.isDestructive {
            if !other.isDestructive {
                return .orderedAscending
            } else {
                return other.ranking.compare(self.ranking)
            }
        } else if self.type == .move && other.type != .move {
            return other.isDestructive ? .orderedAscending : .orderedDescending
        } else if self.isContructive {
            if !other.isContructive {
                return .orderedDescending
            } else {
                return self.ranking.compare(other.ranking)
            }
        } else {
            return .orderedSame
        }
    }

    /// 是否删除
    private var isDestructive: Bool {
        return self.type == .collapse || self.type == .deletion
    }

    /// 是否为创建
    private var isContructive: Bool {
        return self.type == .expansion || self.type == .insertion
    }
}

//MARK: ************************** ZNKBatchChanges ***********************
/// 批量处理
fileprivate class ZNKBatchChanges {

    /// 批量操作数
    private var batchChangesCounter: Int = 0

    /// 批量操作实体数组
    private var operations: [ZNKBatchChangeObject] = []

    init() {
        batchChangesCounter = 0
    }

    /// 开始批量处理
    func beginUpdates() {
        batchChangesCounter += 1
        if batchChangesCounter == 0 {
            operations = []
        }
    }

    /// 结束批量处理
    func endUpdates() {
        batchChangesCounter -= 1
        if batchChangesCounter == 0 {
            operations.sort { (obj1, obj2) -> Bool in
                return obj1.compare(obj2) == .orderedAscending
            }
            for object in operations {
                object.updates()
            }
            operations.removeAll()
        }
    }

    /// 展开item
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - updates: 更新回调
    func expandItem(at indexPath: IndexPath, updates: @escaping (() -> ())) {
        let object = ZNKBatchChangeObject.init(.expansion, ranking: indexPath, updates: updates)
        self.addBatchChangeObject(object)
    }

    /// 插入item
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - updates: 更新回调
    func insertItem(at indexPath: IndexPath, updates: @escaping (() -> ())) {
        let object = ZNKBatchChangeObject.init(.insertion, ranking: indexPath, updates: updates)
        self.addBatchChangeObject(object)
    }

    /// 收缩item
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - updates: 更新回调
    func collapseItem(at indexPath: IndexPath, updates: @escaping (() -> ())) {
        let object = ZNKBatchChangeObject.init(.collapse, ranking: indexPath, updates: updates)
        self.addBatchChangeObject(object)
    }

    /// 移动item
    ///
    /// - Parameters:
    ///   - formIndexPath: 起始地址索引
    ///   - formUpdates: 起始更新回调
    ///   - toIndexPath: 目标地址索引
    ///   - toUpdates: 目标更新回调
    func moveItem(from fromIndexPath: IndexPath, fromUpdates: @escaping (() -> ()), to toIndexPath: IndexPath, toUpdates: @escaping (() -> ())) {
        let fromObject = ZNKBatchChangeObject.init(.deletion, ranking: fromIndexPath, updates: fromUpdates)
        let toObject = ZNKBatchChangeObject.init(.insertion, ranking: toIndexPath, updates: toUpdates)
        self.addBatchChangeObject(fromObject)
        self.addBatchChangeObject(toObject)
    }

    /// 添加批量处理实例
    ///
    /// - Parameter object: 实例对象
    private func addBatchChangeObject(_ object: ZNKBatchChangeObject) {
        if batchChangesCounter > 0 {
            operations.append(object)
        } else {
            object.updates()
        }
    }
}
//MARK: ************************** ZNKTreeNode ***********************

final class ZNKTreeNode {
    /// 父节点
    var parent: ZNKTreeNode?
    /// 子节点数组
    var children: [ZNKTreeNode]
    /// 是否展开
    var expanded: Bool {
        get {
            return item.expand
        }
        set { item.expand = newValue }
    }
    /// 地址索引
    let indexPath: IndexPath
    /// 数据源
    let item: ZNKTreeItem
    /// 节点所处层级
    var level: Int {
        if let p = parent {
            return p.level + 1
        }
        return 0
    }

    /// 可见的子节点数
    var numberOfVisibleChildren: Int {
        get {
            if self.expanded {
                var visibelNumber = self.children.count
                for child in self.children {
                    visibelNumber += child.numberOfVisibleChildren
                }
                return visibelNumber
            } else {
                return 0
            }
        }
    }

    private var mutex: pthread_mutex_t
    /// 初始化
    ///
    /// - Parameters:
    ///   - item: 数据源
    ///   - parent: 父节点
    ///   - children: 子节点数组
    ///   - indexPath: 地址索引
    init(item: ZNKTreeItem, parent: ZNKTreeNode?, children: [ZNKTreeNode] = [], indexPath: IndexPath) {
        self.parent = parent
        self.item = item
        self.indexPath = indexPath
        self.children = children
        mutex = pthread_mutex_t.init()
    }

    /// 删除子节点
    ///
    /// - Parameter child: 子节点
    func remove(_ child: ZNKTreeNode) {
        children = children.filter({$0.item.identifier != child.item.identifier})
    }

    /// 添加子节点
    ///
    /// - Parameter child: 子节点
    func append(_ child: ZNKTreeNode) {
        pthread_mutex_lock(&mutex)
        remove(child)
        children.append(child)
        pthread_mutex_unlock(&mutex)
    }

}

//MARK: ************************** ZNKTreeNodeControllerDelegate ***********************
protocol ZNKTreeNodeControllerDelegate {

    /// 根节点数
    ///
    /// - Returns: 根节点数
    func numberOfRootNode() -> Int

    /// 指定段的指定节点子节点数
    ///
    /// - Parameters:
    ///   - item: 指定item
    ///   - section: 指定段
    /// - Returns: Int
    func numberOfChildrenForNode(_ node: ZNKTreeNode?, atRootIndex index: Int) -> Int

    /// 树形图每个节点的数据源
    ///
    /// - Parameters:
    ///   - childIndex: 子节点下标
    ///   - node: 节点
    ///   - index: 根结点下标
    ///   - expandHandler: 展开回调
    /// - Returns: 节点
    func treeNode(at childIndex: Int, of node: ZNKTreeNode?, atRootIndex index: Int) -> ZNKTreeNode?
}

extension ZNKTreeNodeControllerDelegate {

    /// 默认实现
    ///
    /// - Returns: 1
    func numberOfRootNode() -> Int {
        return 1
    }

}


fileprivate class ZNKTreeNodeController {
    /// 代理
    var delegate: ZNKTreeNodeControllerDelegate?
    /// 根结点互斥锁
    private var rootMutex: pthread_mutex_t
    /// 子节点互斥锁
    private var childMutex: pthread_mutex_t
    /// 结点数组
    private var treeNodes: [ZNKTreeNode] = []

    deinit {
        self.delegate = nil
        pthread_mutex_destroy(&rootMutex)
        pthread_mutex_destroy(&childMutex)
    }

    init() {
        rootMutex = pthread_mutex_t.init()
        childMutex = pthread_mutex_t.init()
    }

    func treeItemForIndexPath(_ indexPath: IndexPath) -> ZNKTreeItem? {
        let rootIndex = indexPath.section
        return nil
    }

    /// 根据item获取节点
    ///
    /// - Parameter item: item
    /// - Returns: 节点
    func treeNodeForItem(_ item: ZNKTreeItem) -> ZNKTreeNode? {
        return treeNodes.filter({$0.item.identifier == item.identifier}).first
    }


    /// 根结点数
    ///
    /// - Returns: 根结点数
    private func numberOfRoot() -> Int {
        return delegate?.numberOfRootNode() ?? 0
    }

    /// 获取根结点
    ///
    /// - Returns: 根结点数组
    func rootTreeNodes() -> [ZNKTreeNode] {
        let rootNumber = numberOfRoot()
        if treeNodes.count == 0 || rootNumber != treeNodes.count{
            for i in 0 ..< numberOfRoot() {
                if let node = delegate?.treeNode(at: 0, of: nil, atRootIndex: i) {
                    append(node)
                    enumericTreeNodes(node)
                }

            }
            return treeNodes
        }
        return treeNodes
    }
    func enumericTreeNodes(_ node: ZNKTreeNode?)  {
        guard let node = node else {
            return
        }
        for child in node.children {
            print("child ---> \(child.item.identifier)")
            enumericTreeNodes(child)
        }
    }

    /// 某个节点子节点数
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - index: 节点下标
    /// - Returns: 子节点数
    private func numberOfChildNode(for node: ZNKTreeNode?, rootIndex: Int) -> Int {
        return delegate?.numberOfChildrenForNode(node, atRootIndex: rootIndex) ?? 0
    }

    /// 某节点的子节点数组
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - rootIndex: 跟节点下标
    private func treeNode(of node: ZNKTreeNode?, at rootIndex: Int) {
        var newNode = node
        let rootNodes = rootTreeNodes()
        if newNode == nil {
            if rootNodes.count - 1 < rootIndex {
                return
            }
            newNode = rootNodes[rootIndex]
        }

        let childNumber = self.numberOfChildNode(for: newNode, rootIndex: rootIndex)
        for i in 0 ..< childNumber {
            pthread_mutex_lock(&childMutex)
            if let childNode = delegate?.treeNode(at: i, of: newNode, atRootIndex: rootIndex) {
                newNode?.append(childNode)
            }
            pthread_mutex_unlock(&childMutex)
        }
        if childNumber > 0 {
            treeNode(of: newNode, at: rootIndex)
        }

    }



    /// 添加结点
    ///
    /// - Parameter root: 根结点
    private func append(_ child: ZNKTreeNode) {
        pthread_mutex_lock(&rootMutex)
        treeNodes = treeNodes.filter({$0.item.identifier != child.item.identifier})
        treeNodes.append(child)
        pthread_mutex_unlock(&rootMutex)
    }

}


//MARK: ************************** ZNKTreeViewDelete ***********************
protocol ZNKTreeViewDelete {

}
//MARK: ************************** ZNKTreeViewDataSource ***********************
protocol ZNKTreeViewDataSource {

    /// 表格根节点数 默认1
    ///
    /// - Parameter treeView: 表格
    /// - Returns: 根节点数
    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int

    /// 每段指定ZNKTreeItem子行数
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    ///   - index: 指定段下标
    /// - Returns: 行数
    func treeView(_ treeView: ZNKTreeView, numberOfChildrenForItem item: ZNKTreeItem?, atRootItemIndex index: Int) -> Int

    /// 树形图每段每行数据源元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - child: 子节点下标
    ///   - item: 数据源
    ///   - root: 根结点下标
    /// - Returns: 数据源
    func treeView(_ treeView: ZNKTreeView, childIndex child: Int, ofItem item: ZNKTreeItem?, atRootIndex root: Int) -> ZNKTreeItem?

    func treeView(_ treeView: ZNKTreeView, cellForItem item: ZNKTreeItem?) -> UITableViewCell

}

extension ZNKTreeViewDataSource {

    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int {
        return 1
    }
}


//MARK: ************************** ZNKTreeView ***********************

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
        return dataSource?.numberOfRootItemInTreeView(self) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.treeView(self, numberOfChildrenForItem: nil, atRootItemIndex: section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let _ = manager.rootTreeNodes()
        let item = manager.treeItemForIndexPath(indexPath)
        let cell = dataSource?.treeView(self, cellForItem: item) ?? .init()
        return cell
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
