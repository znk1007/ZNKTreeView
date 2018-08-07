//
//  ZNKTreeView.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//


import UIKit

/// 元素插入模式
///
/// - leading: 头部
/// - trailing: 尾部
/// - leadingFor: 指定元素头部
/// - trailingFor: 地址元素尾部
enum ZNKTreeItemInsertMode {
    case leading
    case trailing
    case leadingFor(ZNKTreeItem)
    case trailingFor(ZNKTreeItem)
}

//MARK: ************************** ZNKTreeItem ***********************

class ZNKTreeItem {

    /// 唯一标识
    let identifier: String
    /// 是否已展开
    var expand: Bool

    /// 初始化
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识
    ///   - expand: 是否展开
    init(identifier: String, expand: Bool) {
        self.identifier = identifier
        self.expand = expand
    }
}
/// 批量更新类型
fileprivate enum BatchUpdates {
    /// 插入
    case insertion
    /// 删除
    case deletion
    /// 移动
    case move
}

//MARK: *******************IndexSet***********************

fileprivate extension IndexSet {

    /// 从IndexSet获取IndexPath
    ///
    /// - Parameter section: 段
    /// - Returns: [IndexPath]
    func indexPathsForSection(_ section: Int) -> [IndexPath] {
        return self.map({ IndexPath.init(item: $0, section: section) })
    }
}

//MARK: ************************** ZNKTreeNode ***********************

fileprivate class ZNKTreeNode {

    /// 父节点
    var parent: ZNKTreeNode?
    /// 子节点数组
    var children: [ZNKTreeNode]
    /// 是否展开
    var expanded: Bool {
        get {
            return item.expand
        }
        set {
            if self.children.count > 0 {
                item.expand = newValue
            } else {
                item.expand = false
            }
        }
    }
    /// 地址索引
    var indexPath: IndexPath
    /// 数据源
    var item: ZNKTreeItem
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
                var visibleNumber = self.children.count
                for child in self.children {
                    visibleNumber += child.numberOfVisibleChildren
                }
                return visibleNumber
            } else {
                return 0
            }
        }
    }

    /// 插入数据互斥锁
    private var insertMutex: pthread_mutex_t
    /// 更新收缩状态互斥锁
    private var expandMutex: pthread_mutex_t
    /// 初始化
    ///
    /// - Parameters:
    ///   - item: 数据源
    ///   - parent: 父节点
    ///   - children: 子节点数组
    ///   - indexPath: 地址索引
    init(item: ZNKTreeItem, parent: ZNKTreeNode?, children: [ZNKTreeNode] = [], indexPath: IndexPath = IndexPath.init(row: -1, section: -1)) {
        self.parent = parent
        self.item = item
        self.indexPath = indexPath
        self.children = children
        insertMutex = pthread_mutex_t.init()
        expandMutex = pthread_mutex_t.init()
    }

    deinit {
        pthread_mutex_destroy(&insertMutex)
        pthread_mutex_destroy(&expandMutex)
    }


    /// 获取所有可视节点
    ///
    /// - Parameters:
    ///   - index: 下标
    ///   - nodes: 节点数组
    func visibleTreeNode(_ index: inout Int, nodes: inout [ZNKTreeNode]) {
        if self.expanded == true {
            for child in self.children {
                index += 1
                child.indexPath = IndexPath.init(row: index, section: self.indexPath.section)
                objc_sync_enter(self)
                nodes.append(child)
                objc_sync_exit(self)
                child.visibleTreeNode(&index, nodes: &nodes)
            }
        }
    }

    /// 根据ZNKTreeItem获取ZNKTreeNode
    ///
    /// - Parameter item: ZNKTreeItem
    /// - Returns: ZNKTreeNode
    func treeNodeForItem(_ item: ZNKTreeItem) -> ZNKTreeNode? {
        if self.item.identifier == item.identifier {
            return self
        }
        if self.expanded == false {
            return nil
        }
        for child in self.children {
            if let node = child.treeNodeForItem(item) {
                return node
            }
        }
        return nil
    }


    /// 指定地址索引的节点
    ///
    /// - Parameter indexPath: 地址索引
    /// - Returns: 节点
    func nodeForIndexPath(_ indexPath: IndexPath) -> ZNKTreeNode? {
        let this = self
        if this.indexPath.compare(indexPath) == .orderedSame {
            return this
        }
        if this.parent?.expanded == false {
            return nil
        }
        for child in this.children {
            if let childItem =  child.nodeForIndexPath(indexPath) {
                return childItem
            }
        }
        return nil
    }

    /// 更新指定元素的收缩展开状态
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - expand: 是否展开
    ///   - alsoChildren: 是否子元素随展开状态
    @discardableResult
    func updateNodeExpandForItem(_ item: ZNKTreeItem?, expand: Bool, alsoChildren: Bool = false, completion: (([IndexPath]?) -> ())? = nil) -> [IndexPath]? {
        guard let item = item else { return nil }
        if let handler = completion {
            DispatchQueue.global().async {
                if self.item.identifier == item.identifier {
                    var indexPaths: [IndexPath] = []
                    var index: Int = self.indexPath.row + 1
                    if expand {
                        self.expanded = true
                        self.updateAndFetchChildrenExpand(true, alsoChildren: alsoChildren, index: &index, indexPaths: &indexPaths)
                    } else {
                        self.updateAndFetchChildrenExpand(false, alsoChildren: alsoChildren, index: &index, indexPaths: &indexPaths)
                        self.expanded = false
                    }
                    DispatchQueue.main.async {
                        handler(indexPaths)
                    }
                    return
                }
                for child in self.children {
                    child.updateNodeExpandForItem(item, expand: expand, alsoChildren: alsoChildren, completion: completion)
                }
            }
        } else {
            if self.item.identifier == item.identifier {
                var indexPaths: [IndexPath] = []
                var index: Int = self.indexPath.row + 1
                print("current index ===> ", index)
                if expand {
                    self.expanded = true
                    self.updateAndFetchChildrenExpand(true, alsoChildren: alsoChildren, index: &index, indexPaths: &indexPaths)
                } else {
                    self.updateAndFetchChildrenExpand(false, alsoChildren: alsoChildren, index: &index, indexPaths: &indexPaths)
                    self.expanded = false
                }
                for indexPath in indexPaths {
                    print("result indexPath ---> ", indexPath)
                }
                return indexPaths
            }
            for child in self.children {
                if let node = child.updateNodeExpandForItem(item, expand: expand, alsoChildren: alsoChildren, completion: completion) {
                    return node
                }
            }
        }
        return nil
    }

    /// 更新获取展开节点的子节点地址索引
    ///
    /// - Parameters:
    ///   - alsoChildren: 子节点是否全部展开
    ///   - index: 下标
    ///   - indexPaths: 地址索引数组
    func updateAndFetchChildrenExpand(_ expand: Bool, alsoChildren: Bool, index: inout Int, indexPaths: inout [IndexPath]) {
        for child in self.children {
            if alsoChildren {
                child.expanded = expand
            }
            if child.parent?.expanded == true {
                child.indexPath = IndexPath.init(row: index, section: child.indexPath.section)
                pthread_mutex_lock(&expandMutex)
                indexPaths.append(child.indexPath)
                pthread_mutex_unlock(&expandMutex)
                index += 1
            } else {
                child.indexPath = IndexPath.init(row: -1, section: child.indexPath.section)
            }

            child.updateAndFetchChildrenExpand(expand, alsoChildren: alsoChildren, index: &index, indexPaths: &indexPaths)
        }
    }

    func updateAndFetchChilrenFold(_ alsoChildren: Bool, index: inout Int, indexPaths: inout [IndexPath]) {
        for child in self.children {
            if alsoChildren {
                child.expanded = false
            }


        }
    }

    /// 更新所有子元素的展开收缩状态
    ///
    /// - Parameter expand: 展开收缩状态
    func updateChildrenExpand(_ expand: Bool = false, alsoChildren: Bool, index: inout Int, indexPaths: inout [IndexPath]) {

    }

    /// 更新元素
    ///
    /// - Parameter item: 元素
    /// - Returns: ZNKTreeNode
    func reloadTreeNodeForItem(_ item: ZNKTreeItem) -> ZNKTreeNode? {
        if self.item.identifier == item.identifier {
            self.item = item
            return self
        }
        for child in self.children {
            if let node = child.reloadTreeNodeForItem(item) {
                return node
            }
        }
        return nil
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
    func append(_ child: ZNKTreeNode, duple: Bool = true) {
        pthread_mutex_lock(&insertMutex)
        if !duple {
            remove(child)
        }
        children.append(child)
        pthread_mutex_unlock(&insertMutex)
    }

}

//MARK: ************************** ZNKTreeNodeControllerDelegate ***********************
fileprivate protocol ZNKTreeNodeControllerDelegate {

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
    func numberOfChildrenForNode(_ node: ZNKTreeNode?, at rootIndex: Int) -> Int

    /// 树形图每个节点的数据源
    ///
    /// - Parameters:
    ///   - childIndex: 子节点下标
    ///   - node: 节点
    ///   - index: 根结点下标
    ///   - expandHandler: 展开回调
    /// - Returns: 节点
    func treeNode(at childIndex: Int, of node: ZNKTreeNode?, at rootIndex: Int) -> ZNKTreeNode?
}

extension ZNKTreeNodeControllerDelegate {

    /// 默认实现
    ///
    /// - Returns: 1
    func numberOfRootNode() -> Int {
        return 1
    }

}

//MARK: *********************** ZNKTreeNodeController ****************

fileprivate class ZNKTreeNodeController {
    /// 代理
    var delegate: ZNKTreeNodeControllerDelegate?
    /// 根结点互斥锁
    private var rootMutex: pthread_mutex_t
    /// 插入数据互斥锁
    private var insertMutex: pthread_mutex_t
    /// 地址索引互斥锁
    private var indexPathMutex: pthread_mutex_t
    /// 结点数组
    private var treeNodeArray: [ZNKTreeNode] = []

    deinit {
        self.delegate = nil
        pthread_mutex_destroy(&rootMutex)
        pthread_mutex_destroy(&insertMutex)
        pthread_mutex_destroy(&indexPathMutex)
    }

    init() {
        rootMutex = pthread_mutex_t.init()
        insertMutex = pthread_mutex_t.init()
        indexPathMutex = pthread_mutex_t.init()
    }

    /// 获取根结点
    ///
    /// - Returns: 根结点数组
    func rootTreeNodes() {
        let rootNumber = numberOfRoot()
        if rootNumber == 0 {
            treeNodeArray = []
        }
        if treeNodeArray.count == 0 || rootNumber != treeNodeArray.count {
            for i in 0 ..< numberOfRoot() {
                if let node = delegate?.treeNode(at: 0, of: nil, at: i) {
                    node.indexPath = IndexPath.init(row: 0, section: i)
                    appendRootNode(node)
                    var childIndex = 0
                    insertChildNode(of: node, at: i, childIndex: &childIndex)
                }
            }
        }
        sortedByIndexPath()
    }

    /// 可见节点数
    ///
    /// - Parameter index: 根结点下标
    /// - Returns: 可见节点数
    func numberOfVisibleNodeAtIndex(_ index: Int) -> Int {
        guard treeNodeArray.count > index else { return 0 }
        let node = treeNodeArray[index]
        let number = node.numberOfVisibleChildren + 1
        return number
    }

    /// 指定元素下可见子元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - indexPath: 根结点
    /// - Returns: 可见数
    func numberOfVisibleNodeForItem(_ item: ZNKTreeItem, at indexPath: IndexPath?) -> Int {
        if let indexPath = indexPath {
            guard treeNodeArray.count > indexPath.section else { return 0 }
            let rootNode = treeNodeArray[indexPath.section]
            if let theNode = rootNode.treeNodeForItem(item) {
                if theNode.expanded == false {
                    return 0
                }
                return theNode.children.filter({$0.expanded == true}).count
            }
        } else {
            for treeNode in treeNodeArray {
                if let theNode = treeNode.treeNodeForItem(item) {
                    if theNode.expanded == false {
                        return 0
                    }
                    return theNode.children.filter({$0.expanded == true}).count
                }
            }
        }
        return 0
    }

    /// 指定地址索引的根结点
    ///
    /// - Parameter indexPath: 地址索引
    /// - Returns: 根结点
    func rootNodeForIndexPath(_ indexPath: IndexPath) -> ZNKTreeNode? {
        guard treeNodeArray.count > indexPath.section else {
            return nil
        }
        return treeNodeArray[indexPath.section]
    }

    /// 根据indexPath获取item
    ///
    /// - Parameter indexPath: 地址索引
    /// - Returns: ZNKTreeItem
    func treeNodeForIndexPath(_ indexPath: IndexPath) -> ZNKTreeNode? {
        let section = indexPath.section
        guard treeNodeArray.count > section else { return nil }
        let node = treeNodeArray[section]
        return node.nodeForIndexPath(indexPath)
    }

    /// 指定节点下所有显示节点
    ///
    /// - Parameters:
    ///   - treeNode: 指定节点
    ///   - index: 下标
    ///   - nodes: 节点数组
    func visibleChildrenForNode(_ treeNode: ZNKTreeNode, index: inout Int, nodes: inout [ZNKTreeNode]) {
        treeNode.visibleTreeNode(&index, nodes: &nodes)
    }


    /// 指定元素节点
    ///
    /// - Parameter item: 指定元素
    /// - Returns: 节点
    func treeNodeForItem(_ item: ZNKTreeItem, at rootIndex: Int?) -> ZNKTreeNode? {
        if let index = rootIndex {
            guard treeNodeArray.count > index else { return nil }
            return treeNodeArray[index].treeNodeForItem(item)
        } else {
            for treeNode in treeNodeArray {
                return treeNode.treeNodeForItem(item)
            }
        }
        return nil
    }

    /// 获取指定元素所处的层级
    ///
    /// - Parameters:
    ///   - item: ZNKTreeItem
    ///   - indexPath: 地址索引
    /// - Returns: 层级
    func levelfor(_ item: ZNKTreeItem, at indexPath: IndexPath? = nil) -> Int {
        if let indexPath = indexPath {
            guard treeNodeArray.count > indexPath.section else { return -1 }
            let rootNode = treeNodeArray[indexPath.section]
            return rootNode.treeNodeForItem(item)?.level ?? -1
        } else {
            for rootNode in treeNodeArray {
                if let node = rootNode.treeNodeForItem(item) {
                    return node.level
                }
            }
        }
        return -1
    }


    /// 插入元素
    ///
    /// - Parameters:
    ///   - item: 元素
    ///   - parent: 父元素
    ///   - indexPath: 地址索引
    ///   - mode: 元素插入模式
    /// - Returns: 地址索引
    @discardableResult
    func insertItem(_ item: ZNKTreeItem, in parent: ZNKTreeItem?, at rootIndex: Int? = nil, mode: ZNKTreeItemInsertMode, completion: (([IndexPath]?) -> ())? = nil) -> [IndexPath]? {
        if let parent = parent {
            if let index = rootIndex, treeNodeArray.count > index {
                if let parentNode = treeNodeArray[index].treeNodeForItem(parent) {
                    switch mode {
                    case .leading:
                        return insert(item, in: treeNodeArray[index].treeNodeForItem(parent)!, at: 0, completion: completion)
                    case .trailing:
                        return insert(item, in: treeNodeArray[index].treeNodeForItem(parent)!, at: parentNode.children.endIndex, completion: completion)
                    case .leadingFor(let exists):
                        if parentNode.children.count == 0 {
                            return insert(item, in: treeNodeArray[index].treeNodeForItem(parent)!.treeNodeForItem(parent)!, at: 0, completion: completion)
                        } else {
                            if let index = parentNode.children.index(where: {$0.item.identifier == exists.identifier}) {
                                return insert(item, in: treeNodeArray[index].treeNodeForItem(parent)!.treeNodeForItem(parent)!, at: index, completion: completion)
                            }
                        }
                    case .trailingFor(let exists):
                        if parentNode.children.count == 0 {
                            return insert(item, in: treeNodeArray[index].treeNodeForItem(parent)!, at: 0, completion: completion)
                        } else {
                            if let index = parentNode.children.index(where: {$0.item.identifier == exists.identifier}) {
                                return insert(item, in: treeNodeArray[index].treeNodeForItem(parent)!, at: index + 1, completion: completion)
                            }
                        }
                    }
                }
            } else {
                for rootNode in treeNodeArray {
                    if let parentNode = rootNode.treeNodeForItem(parent) {
                        switch mode {
                        case .leading:
                            return insert(item, in: rootNode.treeNodeForItem(parent)!, at: 0, completion: completion)
                        case .trailing:
                            return insert(item, in: rootNode.treeNodeForItem(parent)!, at: parentNode.children.endIndex, completion: completion)
                        case .leadingFor(let exists):
                            if parentNode.children.count == 0 {
                                return insert(item, in: rootNode.treeNodeForItem(parent)!, at: 0, completion: completion)
                            } else {
                                if let index = parentNode.children.index(where: {$0.item.identifier == exists.identifier}) {
                                    return insert(item, in: rootNode.treeNodeForItem(parent)!, at: index, completion: completion)
                                }
                            }
                        case .trailingFor(let exists):
                            if parentNode.children.count == 0 {
                                return insert(item, in: rootNode.treeNodeForItem(parent)!, at: 0, completion: completion)
                            } else {
                                if let index = parentNode.children.index(where: {$0.item.identifier == exists.identifier}) {
                                    return insert(item, in: rootNode.treeNodeForItem(parent)!, at: index + 1, completion: completion)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            let node = ZNKTreeNode.init(item: item, parent: nil)
            switch mode {
            case .leading:
                treeNodeArray.insert(node, at: 0)
            case .trailing:
                treeNodeArray.append(node)
            case .leadingFor(let exists):
                if let index = treeNodeArray.index(where: {$0.item.identifier == exists.identifier}) {
                    treeNodeArray.insert(node, at: index)
                }
            case .trailingFor(let exists):
                if let index = treeNodeArray.index(where: {$0.item.identifier == exists.identifier}) {
                    treeNodeArray.insert(node, at: index + 1)
                }
            }
            var section = 0
            for treeNode in treeNodeArray {
                treeNode.indexPath = IndexPath.init(row: 0, section: section)
                section += 1
            }
            return treeNodeArray.compactMap({$0.indexPath})
        }
        return nil
    }

    /// 插入子节点
    ///
    /// - Parameters:
    ///   - item: 元素
    ///   - parentNode: 父节点
    ///   - index: 下标
    private func insert(_ item: ZNKTreeItem, in parentNode: ZNKTreeNode, at index: Int, completion: (([IndexPath]) -> ())? = nil) -> [IndexPath] {
        if let handler = completion {
            DispatchQueue.global().async {
                let node = ZNKTreeNode.init(item: item, parent: parentNode)
                pthread_mutex_lock(&self.insertMutex)
                parentNode.children.insert(node, at: index)
                pthread_mutex_lock(&self.insertMutex)
                let parentIndexPath = parentNode.indexPath
                var childIndex = parentIndexPath.row + 1
                var indexPaths: [IndexPath] = []
                for child in parentNode.children {
                    let indexPath = IndexPath.init(item: childIndex, section: parentNode.indexPath.section)
                    pthread_mutex_lock(&self.indexPathMutex)
                    indexPaths.append(indexPath)
                    pthread_mutex_unlock(&self.indexPathMutex)
                    child.indexPath = indexPath
                    childIndex += 1
                }
                DispatchQueue.main.async {
                    handler(indexPaths)
                }
            }
            return []
        } else {
            let node = ZNKTreeNode.init(item: item, parent: parentNode)
            pthread_mutex_lock(&insertMutex)
            parentNode.children.insert(node, at: index)
            pthread_mutex_lock(&insertMutex)
            let parentIndexPath = parentNode.indexPath
            var childIndex = parentIndexPath.row + 1
            var indexPaths: [IndexPath] = []
            for child in parentNode.children {
                let indexPath = IndexPath.init(item: childIndex, section: parentNode.indexPath.section)
                pthread_mutex_lock(&indexPathMutex)
                indexPaths.append(indexPath)
                pthread_mutex_unlock(&indexPathMutex)
                child.indexPath = indexPath
                childIndex += 1
            }
            return indexPaths
        }
    }

    /// 删除元素
    ///
    /// - Parameters:
    ///   - item: 子元素
    ///   - root: 根源元素
    /// - Returns: 删除子元素对应地址索引
    @discardableResult
    func deleteItem(_ item: ZNKTreeItem, at rootIndex: Int? = nil, completion: (([IndexPath]?) -> ())? = nil) -> [IndexPath]? {
        if let handler = completion {
            DispatchQueue.global().async {
                if let index = self.treeNodeArray.index(where: {$0.item.identifier == item.identifier}) {
                    self.treeNodeArray.remove(at: index)
                    DispatchQueue.main.async {
                        handler(self.reloadIndexPathsForNodes(self.treeNodeArray, isRoot: true))
                    }
                }
                if let index = rootIndex, self.treeNodeArray.count > index {
                    self.treeNodeArray[index].treeNodeForItem(item)?.parent?.children.remove(at: index)
                    DispatchQueue.main.async {
                        handler(self.reloadIndexPathsForNodes(self.treeNodeArray[index].treeNodeForItem(item)!.parent!.children))
                    }
                } else {
                    for treeNode in self.treeNodeArray {
                        if let theNode = treeNode.treeNodeForItem(item), let parent = theNode.parent, let index = parent.children.index(where: {$0.item.identifier == item.identifier}) {
                            treeNode.treeNodeForItem(item)?.parent?.children.remove(at: index)
                            DispatchQueue.main.async {
                                handler(self.reloadIndexPathsForNodes(treeNode.treeNodeForItem(item)!.parent!.children))
                            }
                        }
                    }
                }
            }
            return nil
        } else {
            if let index = treeNodeArray.index(where: {$0.item.identifier == item.identifier}) {
                treeNodeArray.remove(at: index)
                return reloadIndexPathsForNodes(treeNodeArray, isRoot: true)
            }
            if let index = rootIndex, treeNodeArray.count > index {
                treeNodeArray[index].treeNodeForItem(item)?.parent?.children.remove(at: index)
                return reloadIndexPathsForNodes(treeNodeArray[index].treeNodeForItem(item)!.parent!.children)
            } else {
                for treeNode in treeNodeArray {
                    if let theNode = treeNode.treeNodeForItem(item), let parent = theNode.parent, let index = parent.children.index(where: {$0.item.identifier == item.identifier}) {
                        treeNode.treeNodeForItem(item)?.parent?.children.remove(at: index)
                        return reloadIndexPathsForNodes(treeNode.treeNodeForItem(item)!.parent!.children)
                    }
                }
            }
            return nil
        }
    }

    /// 更新子节点数组的地址索引
    ///
    /// - Parameters:
    ///   - nodes: 子节点数组
    ///   - isRoot: 是否为根结点
    /// - Returns: 地址索引数组
    private func reloadIndexPathsForNodes(_ nodes: [ZNKTreeNode], isRoot: Bool = false) -> [IndexPath] {
        if isRoot {
            var i = 0
            for node in nodes {
                node.indexPath = IndexPath.init(row: 0, section: i)
                i += 1
            }
        } else {
            var i = 0
            for node in nodes {
                node.indexPath = IndexPath.init(row: i, section: node.indexPath.section)
                i += 1
            }
        }
        return nodes.compactMap({$0.indexPath})
    }

    /// 更新元素
    ///
    /// - Parameters:
    ///   - item: 元素
    ///   - indexPath: 根结点地址索引
    /// - Returns: 地址索引
    @discardableResult
    func reloadItem(_ item: ZNKTreeItem, at rootIndex: Int? = nil, completion: ((IndexPath?) -> ())? = nil) -> IndexPath? {
        if let handler = completion {
            DispatchQueue.global().async {
                if let index = rootIndex, self.treeNodeArray.count > index {
                    let rootNode = self.treeNodeArray[index]
                    handler(rootNode.reloadTreeNodeForItem(item)?.indexPath)
                } else {
                    for treeNode in self.treeNodeArray {
                        handler(treeNode.reloadTreeNodeForItem(item)?.indexPath)
                    }
                }
            }
            return nil
        } else {
            if let index = rootIndex, treeNodeArray.count > index {
                let rootNode = treeNodeArray[index]
                return rootNode.reloadTreeNodeForItem(item)?.indexPath
            } else {
                for treeNode in treeNodeArray {
                    return treeNode.reloadTreeNodeForItem(item)?.indexPath
                }
            }
            return nil
        }
    }

    /// 展开指定元素
    ///
    /// - Parameters:
    ///   - item: 指定子元素
    ///   - expand: 是否展开
    ///   - expandChildren: 是否展开子元素
    ///   - rootIndex: 根结点下标
    ///   - completion: 完成回调
    /// - Returns: 地址索引
    @discardableResult
    func updateExpandForItem(_ item: ZNKTreeItem, expand: Bool, expandChildren: Bool, at rootIndex: Int? = nil, completion: (([IndexPath]?) -> ())? = nil) -> [IndexPath]? {
        if let index = rootIndex {
            return treeNodeArray[index].treeNodeForItem(item)?.updateNodeExpandForItem(item, expand: expand, alsoChildren: expandChildren, completion: completion)
        } else {
            for treeNode in treeNodeArray {
                return treeNode.updateNodeExpandForItem(item, expand: expand, alsoChildren: expandChildren, completion: completion)
            }
        }
        return nil
    }

    /// 指定元素节点的所有子节点
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 子节点
    func childrenFor(_ item: ZNKTreeItem) -> [ZNKTreeNode] {
        for rootNode in treeNodeArray {
            if let children = rootNode.treeNodeForItem(item)?.children {
                return children
            }
        }
        return []
    }

    /// 添加根结点
    ///
    /// - Parameter root: 根结点
    func appendRootNode(_ root: ZNKTreeNode) {
        pthread_mutex_lock(&rootMutex)
        treeNodeArray.append(root)
        pthread_mutex_unlock(&rootMutex)
    }

    /// 删除根节点
    ///
    /// - Parameter child: 根节点
    func removeRoot(_ root: ZNKTreeNode) {
        treeNodeArray = treeNodeArray.filter({$0.item.identifier != root.item.identifier})
    }

    /// 根据indexPath升序排序
    func sortedByIndexPath() {
        treeNodeArray.sort { (lhs, rhs) -> Bool in
            return lhs.indexPath.compare(rhs.indexPath) == .orderedAscending
        }
    }

    /// 根结点数
    ///
    /// - Returns: 根结点数
    private func numberOfRoot() -> Int {
        return delegate?.numberOfRootNode() ?? 0
    }


    /// 某个节点子节点数
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - index: 节点下标
    /// - Returns: 子节点数
    private func numberOfChildNode(for node: ZNKTreeNode?, rootIndex: Int) -> Int {
        return delegate?.numberOfChildrenForNode(node, at: rootIndex) ?? 0
    }

    /// 递归存储子节点数据
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - rootIndex: 跟节点下标
    private func insertChildNode(of node: ZNKTreeNode?, at rootIndex: Int, childIndex: inout Int) {
        guard let node = node else { return }
        let childNumber = self.numberOfChildNode(for: node, rootIndex: rootIndex)
        if childNumber == 0 { return }
        for i in 0 ..< childNumber {
            if let childNode = delegate?.treeNode(at: i, of: node, at: rootIndex) {
                if node.expanded {
                    childIndex += 1
                    childNode.indexPath = IndexPath.init(row: childIndex, section: rootIndex)
                }
                node.append(childNode)
                insertChildNode(of: childNode, at: rootIndex, childIndex: &childIndex)
            }
        }
    }
}


//MARK: ************************** ZNKTreeViewDelete ***********************

protocol ZNKTreeViewDelete {

    /// 选择item
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didSelect item: ZNKTreeItem?)

    /// 每个ZNKTreeItem行高
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, heightfor item: ZNKTreeItem?) -> CGFloat

    /// 将要展示单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - cell: UITableViewCell
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willDisplay cell: UITableViewCell, for item: ZNKTreeItem?)

    /// 将要展示段头视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段头视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, willDisplayHeaderView view: UIView, for rootIndex: Int)

    /// 将要展示段尾视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段尾视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, willDisplayFooterView view: UIView, for rootIndex: Int)

    /// 完成单元格展示
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - cell: UITableViewCell
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didEndDisplaying cell: UITableViewCell, for item: ZNKTreeItem?)

    /// 完成段尾视图展示
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段尾视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingFooterView view: UIView, for rootIndex: Int)

    /// 完成段头视图展示
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段头视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingHeaderView view: UIView, for rootIndex: Int)

    /// 段头高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, heightForHeaderIn rootIndex: Int) -> CGFloat

    /// 段尾高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, heightForFooterIn rootIndex: Int) -> CGFloat

    /// 单元格预设高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, estimatedHeightFor item: ZNKTreeItem?) -> CGFloat

    /// 段头预设高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForHeaderIn rootIndex: Int) -> CGFloat

    /// 段尾预设高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForFooterIn rootIndex: Int) -> CGFloat

    /// 段头视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 段头视图
    func treeView(_ treeView: ZNKTreeView, viewForHeaderIn rootIndex: Int) -> UIView?

    /// 段头视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 段头视图
    func treeView(_ treeView: ZNKTreeView, viewForFooterIn rootIndex: Int) -> UIView?

    /// 点击单元格右侧指示按钮事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, accessoryButtonTappedFor item: ZNKTreeItem?)

    /// 是否对ZNKTreeItem高亮
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldHighlightFor item: ZNKTreeItem?) -> Bool

    /// 已对ZNKTreeItem高亮
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, didHighlightFor item: ZNKTreeItem?)

    /// 已对ZNKTreeItem取消高亮
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, didUnhighlightFor item: ZNKTreeItem?)

    /// 将要选择单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willSelect item: ZNKTreeItem?) -> ZNKTreeItem?

    /// 将要取消选择单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willDeselect item: ZNKTreeItem?) -> ZNKTreeItem?

    /// 已取消选择单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didDeselect item: ZNKTreeItem?)

    /// 单元格编辑类型风格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UITableViewCellEditingStyle
    func treeView(_ treeView: ZNKTreeView, editingStyleFor item: ZNKTreeItem?) -> UITableViewCellEditingStyle

    /// 删除按钮标题
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 标题
    func treeView(_ treeView: ZNKTreeView, titleForDeleteConfirmationButtonFor item: ZNKTreeItem?) -> String?

    /// 单元格事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UITableViewRowAction
    func treeView(_ treeView: ZNKTreeView, editActionsFor item: ZNKTreeItem?) -> [UITableViewRowAction]?

    /// 右滑手势配置
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UISwipeActionsConfiguration
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, leadingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration?

    /// 左滑手势配置
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UISwipeActionsConfiguration
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, trailingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration?

    /// 单元格编辑过程中是否缩进，默认true
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldIndentWhileEditingFor item: ZNKTreeItem?) -> Bool

    /// 将要编辑单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willBeginEditingFor item: ZNKTreeItem?)

    /// 已完成单元格编辑
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didEndEditingFor item: ZNKTreeItem?)

    /// 编辑单元格拖行时所经过的ZNKTreeItem
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - sourceItem: 源ZNKTreeItem
    ///   - item: 目标ZNKTreeItem
    /// - Returns: 所经过的ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, targetItemForMoveFrom sourceItem: ZNKTreeItem?, toProposed item: ZNKTreeItem?) -> ZNKTreeItem?

    /// 缩进等级
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Int 缩进等级
    func treeView(_ treeView: ZNKTreeView, indentationLevelFor item: ZNKTreeItem?) -> Int

    /// 是否需要显示菜单
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldShowMenuFor item: ZNKTreeItem?) -> Bool

    /// 单元格是否可以响应指定事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - action: Selector
    ///   - item: ZNKTreeItem
    ///   - sender: Any
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canPerformAction action: Selector, for item: ZNKTreeItem?, withSender sender: Any?) -> Bool

    /// 单元格响应指定事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - action: Selector
    ///   - item: ZNKTreeItem
    ///   - sender: Any
    func treeView(_ treeView: ZNKTreeView, performAction action: Selector, for item: ZNKTreeItem?, with sender: Any?)

    /// 单元格可以聚焦
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canFocus item: ZNKTreeItem?) -> Bool

    /// 是否需要更新聚焦状态
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - context: UITableViewFocusUpdateContext
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool

    /// 完成聚焦更新
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - context: UITableViewFocusUpdateContext
    ///   - coordinator: UIFocusAnimationCoordinator
    func treeView(_ treeView: ZNKTreeView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)

    /// 聚焦的ZNKTreeItem
    ///
    /// - Parameter treeView: ZNKTreeView
    /// - Returns: 聚焦的ZNKTreeItem
    func itemForPreferredFocusedView(in treeView: ZNKTreeView) -> ZNKTreeItem?


    /// 弹性加载ZNKTreeItem
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    ///   - context: UISpringLoadedInteractionContext
    /// - Returns: Bool
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, shouldSpringLoad item: ZNKTreeItem?, with context: UISpringLoadedInteractionContext) -> Bool

    /// 是否可以展开元素，默认true
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canExpandItem item: ZNKTreeItem) -> Bool

    /// 将要展开元素
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, willExpandItem item: ZNKTreeItem)

    /// 已完成元素展开
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, didExpandItem item: ZNKTreeItem)

    /// 是否可以收缩元素，默认true
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canFoldItem item: ZNKTreeItem) -> Bool

    /// 将要收缩元素
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, willFoldItem item: ZNKTreeItem)

    /// 已完成元素收缩
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, didFoldItem item: ZNKTreeItem)
}

extension ZNKTreeViewDelete {
    func treeView(_ treeView: ZNKTreeView, didSelect item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, heightfor item: ZNKTreeItem?) -> CGFloat { return 0 }
    func treeView(_ treeView: ZNKTreeView, willDisplay cell: UITableViewCell, for item: ZNKTreeItem?)  { }
    func treeView(_ treeView: ZNKTreeView, willDisplayHeaderView view: UIView, for rootIndex: Int) {}
    func treeView(_ treeView: ZNKTreeView, willDisplayFooterView view: UIView, for rootIndex: Int) {}
    func treeView(_ treeView: ZNKTreeView, didEndDisplaying cell: UITableViewCell, for item: ZNKTreeItem?) { }
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingHeaderView view: UIView, for rootIndex: Int) { }
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingFooterView view: UIView, for rootIndex: Int) {}
    func treeView(_ treeView: ZNKTreeView, heightForHeaderIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, heightForFooterIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, estimatedHeightFor item: ZNKTreeItem?) -> CGFloat { return 45 }
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForHeaderIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForFooterIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, viewForHeaderIn rootIndex: Int) -> UIView? { return nil }
    func treeView(_ treeView: ZNKTreeView, viewForFooterIn rootIndex: Int) -> UIView? { return nil }
    func treeView(_ treeView: ZNKTreeView, accessoryButtonTappedFor item: ZNKTreeItem?) { }
    func treeView(_ treeView: ZNKTreeView, shouldHighlightFor item: ZNKTreeItem?) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, didHighlightFor item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, didUnhighlightFor item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, willSelect item: ZNKTreeItem?) -> ZNKTreeItem? { return nil }
    func treeView(_ treeView: ZNKTreeView, willDeselect item: ZNKTreeItem?) -> ZNKTreeItem? { return nil }
    func treeView(_ treeView: ZNKTreeView, didDeselect item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, editingStyleFor item: ZNKTreeItem?) -> UITableViewCellEditingStyle { return .none }
    func treeView(_ treeView: ZNKTreeView, titleForDeleteConfirmationButtonFor item: ZNKTreeItem?) -> String? { return nil }
    func treeView(_ treeView: ZNKTreeView, editActionsFor item: ZNKTreeItem?) -> [UITableViewRowAction]? { return nil }
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, leadingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration? { return nil }
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, trailingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration? { return nil }
    func treeView(_ treeView: ZNKTreeView, shouldIndentWhileEditingFor item: ZNKTreeItem?) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, willBeginEditingFor item: ZNKTreeItem?) { }
    func treeView(_ treeView: ZNKTreeView, didEndEditingFor item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, targetItemForMoveFrom sourceItem: ZNKTreeItem?, toProposed item: ZNKTreeItem?) -> ZNKTreeItem? { return nil }
    func treeView(_ treeView: ZNKTreeView, indentationLevelFor item: ZNKTreeItem?) -> Int { return 0 }
    func treeView(_ treeView: ZNKTreeView, shouldShowMenuFor item: ZNKTreeItem?) -> Bool { return false }
    func treeView(_ treeView: ZNKTreeView, canPerformAction action: Selector, for item: ZNKTreeItem?, withSender sender: Any?) -> Bool { return false }
    func treeView(_ treeView: ZNKTreeView, performAction action: Selector, for item: ZNKTreeItem?, with sender: Any?) { }
    func treeView(_ treeView: ZNKTreeView, canFocus item: ZNKTreeItem?) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) { }
    func itemForPreferredFocusedView(in treeView: ZNKTreeView) -> ZNKTreeItem? { return nil }
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, shouldSpringLoad item: ZNKTreeItem?, with context: UISpringLoadedInteractionContext) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, canExpandItem item: ZNKTreeItem) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, willExpandItem item: ZNKTreeItem) { }
    func treeView(_ treeView: ZNKTreeView, didExpandItem item: ZNKTreeItem) { }
    func treeView(_ treeView: ZNKTreeView, canFoldItem item: ZNKTreeItem) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, willFoldItem item: ZNKTreeItem) { }
    func treeView(_ treeView: ZNKTreeView, didFoldItem item: ZNKTreeItem) { }
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
    func treeView(_ treeView: ZNKTreeView, numberOfChildrenFor item: ZNKTreeItem?, at rootIndex: Int) -> Int

    /// 树形图每段每行数据源元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - child: 子节点下标
    ///   - item: 数据源
    ///   - root: 根结点下标
    /// - Returns: 数据源
    func treeView(_ treeView: ZNKTreeView, childIndex child: Int, ofItem item: ZNKTreeItem?, at rootIndex: Int) -> ZNKTreeItem?

    /// 数据源展示单元格
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 展示数据源
    /// - Returns: UITableViewCell
    func treeView(_ treeView: ZNKTreeView, cellFor item: ZNKTreeItem?, at indexPath: IndexPath) -> UITableViewCell

    /// 编辑item
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - editingStyle: 编辑类型
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, commit editingStyle: UITableViewCellEditingStyle, for item: ZNKTreeItem?)

    /// item是否可以编辑
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canEditFor item: ZNKTreeItem?) -> Bool

    /// 段头标题
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - index: 根结点下标
    /// - Returns: 标题
    func treeView(_ treeView: ZNKTreeView, titleForHeaderInRootIndex index: Int) -> String?

    /// 段尾标题
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - index: 根结点下标
    /// - Returns: 标题
    func treeView(_ treeView: ZNKTreeView, titleForFooterInRootIndex index: Int) -> String?

    /// 是否可移动ZNKTreeItem
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canMoveFor item: ZNKTreeItem?) -> Bool

    /// 索引数组
    ///
    /// - Parameter treeView: ZNKTreeView
    /// - Returns: 索引数组
    func sectionIndexTitles(for treeView: ZNKTreeView) -> [String]?

    /// 索引所在的位置
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - title: 标题
    ///   - index: 下标
    /// - Returns: 位置
    func treeView(_ treeView: ZNKTreeView, sectionForSectionIndexTitle title: String, at index: Int) -> Int

    /// 将item从源地址索引移动到目标地址索引
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - sourceIndexPath: 源地址索引
    ///   - destinationIndexPath: 目标地址索引
    func treeView(_ treeView: ZNKTreeView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

extension ZNKTreeViewDataSource {

    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int {
        return 1
    }
    func treeView(_ treeView: ZNKTreeView, commit editingStyle: UITableViewCellEditingStyle, for item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, canEditFor item: ZNKTreeItem?) -> Bool { return false }
    func treeView(_ treeView: ZNKTreeView, titleForHeaderInRootIndex index: Int) -> String? { return nil }
    func treeView(_ treeView: ZNKTreeView, titleForFooterInRootIndex index: Int) -> String? { return nil }
    func treeView(_ treeView: ZNKTreeView, canMoveFor item: ZNKTreeItem?) -> Bool { return false }
    func sectionIndexTitles(for treeView: ZNKTreeView) -> [String]? { return nil }
    func treeView(_ treeView: ZNKTreeView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { return -1 }
    func treeView(_ treeView: ZNKTreeView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
}


//protocol ZNKTreeViewDataSourcePrefetching {
//
//    /// 展示前预取ZNKTreeItem数组
//    ///
//    /// - Parameters:
//    ///   - treeView: ZNKTreeView
//    ///   - items: ZNKTreeItem数组
//    func treeView(_ treeView: ZNKTreeView, prefecth items: [ZNKTreeItem])
//}


//extension ZNKTreeViewDataSourcePrefetching {
//    func treeView(_ treeView: ZNKTreeView, prefecth items: [ZNKTreeItem]) { }
//}


//MARK: ************************** ZNKTreeView ***********************

final class ZNKTreeView: UIView {

    //MARK: ******Public*********

    /// 代理
    var delegate: ZNKTreeViewDelete?
    /// 数据源
    var dataSource: ZNKTreeViewDataSource?
    /// 预取数据源
    //    var prefetchDataSource: ZNKTreeViewDataSourcePrefetching?
    /// 预估行高 默认0
    var estimatedRowHeight: CGFloat = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.estimatedRowHeight = estimatedRowHeight
        }
    }

    /// 是否同步
    var async: Bool = false

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

    /// 分割线嵌入
    var separatorInset: UIEdgeInsets = .zero {
        didSet {
            guard let table = treeTable else { return }
            table.separatorInset = separatorInset
        }
    }


    /// 树形图行高
    var treeViewRowHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            guard let table = treeTable else { return }
            table.rowHeight = treeViewRowHeight
        }
    }

    /// 分割风格
    var separatorStyle: ZNKTreeViewCellSeperatorStyle = .none {
        didSet {
            guard let table = treeTable else { return }
            table.separatorStyle = separatorStyle.style
        }
    }

    /// 分割颜色
    var separatorColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.separatorColor = separatorColor
        }
    }

    /// 调整右侧像素
    var cellLayoutMarginsFollowReadableWidth: Bool = false {
        didSet {
            guard let table = treeTable else { return }
            table.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        }
    }

    /// 分割效果
    var seperatorEffect: UIVisualEffect? {
        didSet {
            guard let table = treeTable else { return }
            table.separatorEffect = seperatorEffect
        }
    }
    // 段头高度 默认 UITableViewAutomaticDimension
    var sectionHeaderHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            guard let table = treeTable else { return }
            table.sectionHeaderHeight = sectionHeaderHeight
        }
    }
    // 段尾高度 默认 UITableViewAutomaticDimension
    var sectionFooterHeight: CGFloat = UITableViewAutomaticDimension{
        didSet {
            guard let table = treeTable else { return }
            table.sectionFooterHeight = sectionFooterHeight
        }
    }

    /// 元素是否在编辑状态
    var isItemEditing: Bool {
        set {
            guard let table = treeTable else { return }
            table.isEditing = newValue
        }
        get {
            guard let table = treeTable else { return false }
            return table.isEditing
        }
    }

    /// 非编辑状态下是否可选
    var allowsItemSelection: Bool {
        set {
            guard let table = treeTable else { return }
            table.allowsSelection = allowsItemSelection
        }
        get {
            guard let table = treeTable else { return false }
            return table.allowsSelection
        }
    }

    /// 编辑状态下是否可选
    var allowsItemSelectionDuringEditing: Bool {
        set {
            guard let table = treeTable else { return }
            table.allowsSelectionDuringEditing = allowsItemSelectionDuringEditing
        }
        get {
            guard let table = treeTable else { return false }
            return table.allowsSelectionDuringEditing
        }
    }


    /// 是否允许多选
    var allowsMultipleItemSelection: Bool {
        set {
            guard let table = treeTable else { return }
            table.allowsMultipleSelection = allowsMultipleItemSelection
        }
        get {
            guard let table = treeTable else { return false }
            return table.allowsMultipleSelection
        }
    }

    /// 编辑状态下是否可以多选
    var allowsMultipleItemSelectionDuringEditing: Bool {
        get {
            guard let table = treeTable else { return false }
            return table.allowsMultipleSelectionDuringEditing
        }
        set {
            guard let table = treeTable else { return }
            table.allowsMultipleSelectionDuringEditing = allowsMultipleItemSelectionDuringEditing
        }
    }

    /// 选中元素的地址索引
    var indexPathForSelectedItem: IndexPath? {
        guard let table = treeTable else { return nil }
        return table.indexPathForSelectedRow
    }
    /// 选中元素的地址索引数组
    var indexPathsForSelectedItems: [IndexPath]? {
        guard let table = treeTable else { return nil }
        return table.indexPathsForVisibleRows

    }

    /// 每段最少显示元素数
    var sectionIndexMinimumDisplayItemCount: Int = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexMinimumDisplayRowCount = sectionIndexMinimumDisplayItemCount
        }
    }

    /// 段下标颜色
    var sectionIndexColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexColor = sectionIndexColor
        }
    }

    /// 段下标背景颜色
    var sectionIndexBackgroundColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexBackgroundColor = sectionIndexBackgroundColor
        }
    }

    /// /// 段下标轨迹背景颜色
    var sectionIndexTrackingBackgroundColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexTrackingBackgroundColor = sectionIndexTrackingBackgroundColor
        }
    }

    /// 内容视图嵌入安全域
    var insetsContentViewsToSafeArea: Bool = true {
        didSet {
            guard let table = treeTable else { return }
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
            guard let table = treeTable else { return }
            table.tableHeaderView = treeHeaderView
        }
    }

    /// 树形图尾部视图
    var treeFooterView: UIView? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.tableFooterView = treeFooterView
        }
    }

    /// 记住最后选中的元素
    var remembersLastFocusedItem: Bool = false {
        didSet {
            guard let table = treeTable else { return }
            table.remembersLastFocusedIndexPath = remembersLastFocusedItem
        }
    }

    /// 是否允许拖拽
    var dragInteractionEnabled: Bool = false {
        didSet {
            guard let table = treeTable else { return }
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
            guard let table = treeTable else { return false }
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
        guard let table = treeTable else { return 0 }
        return table.numberOfSections
    }

    /// 展开元素时，是否同时展开所有子元素，默认false
    var expandChildrenWhenItemExpand: Bool = false

    /// 展开元素动画模式 默认none
    var expandAnimation: ZNKTreeViewRowAnimation = .none

    /// 收缩元素时，是否同时收缩所有子元素，默认false
    var foldChildrenWhenItemFold: Bool = false

    /// 收缩动画模式，默认none
    var foldAnimation: ZNKTreeViewRowAnimation = .none

    //MARK: ******Private*********
    /// 表格
    private var treeTable: UITableView!

    /// 显示类型
    private var style: ZNKTreeViewStyle = .plain

    /// 节点管理
    private var manager: ZNKTreeNodeController?

    /// 插入数据互斥锁
    private var insertMutex: pthread_mutex_t = .init()
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 坐标及大小
    ///   - style: 类型
    init(frame: CGRect, style: ZNKTreeViewStyle) {
        super.init(frame: frame)
        self.insertMutex = pthread_mutex_t.init()
        self.style = style
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.style = .plain
        self.commonInit()
    }

    deinit {
        treeTable.delegate = nil
        treeTable.dataSource = nil
        treeTable = nil
        manager = nil
        pthread_mutex_destroy(&insertMutex)
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
        self.treeTable = UITableView.init(frame: bounds, style: style.tableStyle)
        treeTable.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        treeTable.estimatedRowHeight = 0
        treeTable.estimatedSectionHeaderHeight = 0
        treeTable.estimatedSectionFooterHeight = 0
        treeTable.dataSource = self
        treeTable.delegate = self
        self.addSubview(treeTable)
        allowsItemSelection = true
        allowsMultipleItemSelection = false
        allowsItemSelectionDuringEditing = false
    }

    /// 初始化配置
    private func initConfiguration() {
        manager = .init()
        manager?.delegate = self
    }
}

extension ZNKTreeView {
    /// 树形图展示类型
    ///
    /// - grouped: 分组
    /// - plain: 平铺
    enum ZNKTreeViewStyle {
        case grouped
        case plain
        var tableStyle: UITableViewStyle {
            switch self {
            case .grouped:
                return UITableViewStyle.grouped
            case .plain:
                return UITableViewStyle.plain
            }
        }

    }

    /// 单元格分割风格
    ///
    /// - none: 无
    /// - singleLine: 单线
    /// - singleLineEtched: 单线蚀刻
    enum ZNKTreeViewCellSeperatorStyle {
        case none
        case singleLine
        case singleLineEtched
        var style: UITableViewCellSeparatorStyle {
            switch self {
            case .none:
                return UITableViewCellSeparatorStyle.none
            case .singleLine:
                return UITableViewCellSeparatorStyle.singleLine
            case .singleLineEtched:
                return UITableViewCellSeparatorStyle.singleLineEtched
            }
        }

    }

    /// 表格滚动位置
    ///
    /// - none: 无
    /// - top: 顶部
    /// - middle: 中间
    /// - bottom: 底部
    enum ZNKTreeViewScrollPosition {
        case none
        case top
        case middle
        case bottom
        var position: UITableViewScrollPosition {
            switch self {
            case .none:
                return UITableViewScrollPosition.none
            case .top:
                return UITableViewScrollPosition.top
            case .middle:
                return UITableViewScrollPosition.middle
            case .bottom:
                return UITableViewScrollPosition.bottom
            }
        }

    }

    /// 单元格动画效果
    ///
    /// - fade: 渐褪
    /// - right: 向右
    /// - left: 向左
    /// - top: 顶部
    /// - bottom: 底部
    /// - middle: 中间
    /// - automatic: 自动
    enum ZNKTreeViewRowAnimation {
        case none
        case fade
        case right
        case left
        case top
        case bottom
        case middle
        case automatic
        var animation: UITableViewRowAnimation {
            switch self {
            case .none:
                return UITableViewRowAnimation.none
            case .fade:
                return UITableViewRowAnimation.fade
            case .right:
                return UITableViewRowAnimation.right
            case .left:
                return UITableViewRowAnimation.left
            case .top:
                return UITableViewRowAnimation.top
            case .bottom:
                return UITableViewRowAnimation.bottom
            case .middle:
                return UITableViewRowAnimation.middle
            case .automatic:
                return UITableViewRowAnimation.automatic
            }
        }
    }
}

//MARK: ************ public methods ******************
extension ZNKTreeView {

    /// 指定元素层级
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - indexRootPath: 根结点地址索引
    /// - Returns: 层级
    func levelFor(_ item: ZNKTreeItem, at indexRootPath: IndexPath? = nil) -> Int {
        return manager?.levelfor(item, at: indexRootPath) ?? -1
    }

    /// 指定元素地址索引
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - indexPath: 根结点地址索引
    /// - Returns: 地址索引
    func indexPathFor(_ item: ZNKTreeItem, at indexPath: IndexPath? = nil ) -> IndexPath? {
        return manager?.treeNodeForItem(item, at: indexPath?.section)?.indexPath
    }

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
        manager?.rootTreeNodes()
        if #available(iOS 11, *) {
            if !table.hasUncommittedUpdates {
                table.reloadData()
            }
        } else {
            table.reloadData()
        }
    }

    /// 根元素下所有显示的子元素数量
    ///
    /// - Parameter rootIndex: 根下标
    /// - Returns: 子元素数量
    func numberOfChildren(inRoot index: Int) -> Int {
        guard let table = treeTable else { return 0 }
        return table.numberOfRows(inSection: index)
    }

    /// 包括头部，尾部，所有行的边框
    ///
    /// - Parameter index: 根下标
    /// - Returns: CGRect
    func treeRect(forRoot index: Int) -> CGRect {
        guard let table = treeTable else { return .zero }
        return table.rect(forSection: index)
    }

    /// 头部边框
    ///
    /// - Parameter index: 根下标
    /// - Returns: CGRect
    func treeRectForHeader(inRoot index: Int) -> CGRect {
        guard let table = treeTable else { return .zero }
        return table.rectForHeader(inSection: index)
    }

    /// 尾部边框
    ///
    /// - Parameter index: 根下标
    /// - Returns: CGRect
    func treeRectForFooter(inRoot index: Int) -> CGRect {
        guard let table = treeTable else { return .zero }
        return table.rectForFooter(inSection: index)
    }

    /// 指定元素边框
    ///
    /// - Parameter item: 指定元素
    /// - Returns: CGRect
    func treeRectForItem(_ item: ZNKTreeItem, at indexPath: IndexPath) -> CGRect {
        guard let table = treeTable, let indexPath = manager?.treeNodeForItem(item, at: indexPath.section)?.indexPath else { return .zero }
        return table.rectForRow(at: indexPath)
    }

    /// 指定坐标的元素, 超出表格，则为nil
    ///
    /// - Parameter point: 坐标
    /// - Returns: 元素
    func treeItem(at point: CGPoint) -> ZNKTreeItem? {
        guard let table = treeTable, let indexPath = table.indexPathForRow(at: point) else { return nil }
        return manager?.treeNodeForIndexPath(indexPath)?.item
    }

    /// 指定单元格的元素
    ///
    /// - Parameter cell: 单元格
    /// - Returns: 元素
    func treeItem(for cell: UITableViewCell) -> ZNKTreeItem? {
        guard let table = treeTable, let indexPath = table.indexPath(for: cell) else { return nil }
        return manager?.treeNodeForIndexPath(indexPath)?.item
    }

    /// 指定边框的所有元素
    ///
    /// - Parameter rect: 边框
    /// - Returns: 元素数组
    func treeItems(in rect: CGRect) -> [ZNKTreeItem]? {
        guard let table = treeTable, let indexPaths = table.indexPathsForRows(in: rect) else { return nil }
        var items: [ZNKTreeItem] = []
        for indexPath in indexPaths {
            if let item = manager?.treeNodeForIndexPath(indexPath)?.item {
                objc_sync_enter(self)
                items.append(item)
                objc_sync_exit(self)
            }
        }
        return items
    }

    /// 指定元素的单元格
    ///
    /// - Parameter item: 指定元素
    /// - Returns: 单元格
    func cell(for item: ZNKTreeItem, at indexPath: IndexPath?) -> UITableViewCell? {
        guard let table = treeTable, let indexPath = manager?.treeNodeForItem(item, at: indexPath?.section)?.indexPath else { return nil }
        return table.cellForRow(at: indexPath)
    }

    /// 可见的元素数组
    var visibleItems: [ZNKTreeItem] {
        guard let table = treeTable else { return [] }
        var items: [ZNKTreeItem] = []
        for cell in table.visibleCells {
            if let item = treeItem(for: cell) {
                objc_sync_enter(self)
                items.append(item)
                objc_sync_exit(self)
            }
        }
        return items
    }

    /// 段头视图
    ///
    /// - Parameter index: 根元素下标
    /// - Returns: 段头视图
    func treeHeaderView(forRoot index: Int) -> UITableViewHeaderFooterView? {
        guard let table = treeTable else { return nil }
        return table.headerView(forSection: index)
    }

    /// 段尾视图
    ///
    /// - Parameter index: 根元素下标
    /// - Returns: 段尾视图
    func treeFooterView(forRoot index: Int) -> UITableViewHeaderFooterView? {
        guard let table = treeTable else { return nil }
        return table.footerView(forSection: index)
    }

    /// 滚动到指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - position: 滚动位置
    ///   - animated: 动画
    func scrollToItem(_ item: ZNKTreeItem, at indexPath: IndexPath? = nil, at position: ZNKTreeViewScrollPosition, animated: Bool) {
        guard let table = treeTable, let indexPath = manager?.treeNodeForItem(item, at: indexPath?.section)?.indexPath else { return }
        table.scrollToRow(at: indexPath, at: position.position, animated: animated)
    }

    /// 滚动至选择item附件
    ///
    /// - Parameters:
    ///   - position: 滚动位置
    ///   - animated: 动画
    func scrollToNearestSelectedItem(at position: ZNKTreeViewScrollPosition, animated: Bool) {
        guard let table = treeTable else { return }
        table.scrollToNearestSelectedRow(at: position.position, animated: animated)
    }

    /// 插入元素数组
    ///
    /// - Parameters:
    ///   - items: 元素数组
    ///   - parent: 父元素
    ///   - indexPath: 地址索引
    ///   - mode: 模式
    ///   - animation: 动画
    func insertItems(_ items: [ZNKTreeItem], in parent: ZNKTreeItem?, at rootIndex: Int, mode: ZNKTreeItemInsertMode = .leading, animation: ZNKTreeViewRowAnimation = .none) {
        guard self.treeTable != nil else { return }
        for item in items {
            insertItem(item, in: parent, at: rootIndex, mode: mode, animation: animation)
        }
    }

    /// 插入元素
    ///
    /// - Parameters:
    ///   - item: 元素
    ///   - parent: 父元素
    ///   - indexPath: 地址索引
    ///   - mode: 模式
    ///   - animation: 动画
    func insertItem(_ item: ZNKTreeItem, in parent: ZNKTreeItem?, at rootIndex: Int, mode: ZNKTreeItemInsertMode = .leading, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = self.treeTable else { return }
        if async {
            manager?.insertItem(item, in: parent, at: rootIndex, mode: mode, completion: { [weak self](indexPaths) in
                if let indexPaths = indexPaths {
                    if #available(iOS 11, *) {
                        self?.treeTable.performBatchUpdates({
                            self?.treeTable.insertRows(at: indexPaths, with: animation.animation)
                        }, completion: nil)
                    } else {
                        self?.treeTable.beginUpdates()
                        self?.treeTable.insertRows(at: indexPaths, with: animation.animation)
                        self?.treeTable.endUpdates()
                    }
                }
            })
        } else {
            guard let childIndexPaths = manager?.insertItem(item, in: parent, at: rootIndex, mode: mode) else { return }
            if #available(iOS 11, *) {
                table.performBatchUpdates({
                    self.treeTable.insertRows(at: childIndexPaths, with: animation.animation)
                }, completion: nil)
            } else {
                table.beginUpdates()
                self.treeTable.insertRows(at: childIndexPaths, with: animation.animation)
                table.endUpdates()
            }
        }
    }


    /// 删除指定元素数组
    ///
    /// - Parameters:
    ///   - items: 指定元素数组
    ///   - parent: 父元素
    ///   - animation: 动画
    func deleteItems(_ items: [ZNKTreeItem], at rootIndex: Int, animation: ZNKTreeViewRowAnimation = .none)  {
        guard self.treeTable != nil else { return }
        for item in items {
            deleteItem(item, at: rootIndex, animation: animation)
        }
    }

    /// 删除指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - parent: 父元素
    ///   - animation: 动画
    func deleteItem(_ item: ZNKTreeItem, at rootIndex: Int, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = self.treeTable else { return }
        if async {
            manager?.deleteItem(item, at: rootIndex, completion: { (indexPaths) in
                if let indexPaths = indexPaths {
                    if #available(iOS 11, *) {
                        table.performBatchUpdates({
                            self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                        }, completion: nil)
                    } else {
                        table.beginUpdates()
                        self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                        table.endUpdates()
                    }
                }
            })
        } else {
            guard let indexPaths = manager?.deleteItem(item, at: rootIndex) else { return }
            if #available(iOS 11, *) {
                table.performBatchUpdates({
                    self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                }, completion: nil)
            } else {
                table.beginUpdates()
                self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                table.endUpdates()
            }
        }
    }

    /// 更新指定元素
    ///
    /// - Parameters:
    ///   - item: 指定
    ///   - rootIndex: 跟节点地址
    ///   - animation: 动画
    func reloadItem(_ item: ZNKTreeItem, at rootIndex: Int, animation: ZNKTreeViewRowAnimation = .none)  {
        guard let table = self.treeTable else { return }
        if async {
            manager?.reloadItem(item, at: rootIndex, completion: { (indexPath) in
                if let indexPath = indexPath {
                    if #available(iOS 11, *) {
                        table.performBatchUpdates({
                            table.reloadRows(at: [indexPath], with: animation.animation)
                        }, completion: nil)
                    } else {
                        table.beginUpdates()
                        table.reloadRows(at: [indexPath], with: animation.animation)
                        table.endUpdates()
                    }
                }
            })
        } else {
            guard let indexPath = manager?.reloadItem(item, at: rootIndex) else { return }
            if #available(iOS 11, *) {
                table.performBatchUpdates({
                    table.reloadRows(at: [indexPath], with: animation.animation)
                }, completion: nil)
            } else {
                table.beginUpdates()
                table.reloadRows(at: [indexPath], with: animation.animation)
                table.endUpdates()
            }
        }
    }

    /// 展开指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - expandChildren: 是否展开指定元素的子元素
    ///   - rootIndex: 根结点数
    ///   - animation: 动画
    func expandItem(_ item: ZNKTreeItem, expandChildren: Bool, at rootIndex: Int, animation: ZNKTreeViewRowAnimation) {
        guard let table = treeTable else { return }
        if item.expand == true {
            return
        }
        if async {
            manager?.updateExpandForItem(item, expand: true, expandChildren: expandChildren, at: rootIndex, completion: { [weak self] (indexPaths) in
                if let indexPaths = indexPaths, indexPaths.count > 0 {
                    if #available(iOS 11, *) {
                        self?.treeTable.performBatchUpdates({
                            self?.treeTable.insertRows(at: indexPaths, with: animation.animation)
                        }, completion: nil)
                    } else {
                        self?.treeTable.beginUpdates()
                        self?.treeTable.insertRows(at: indexPaths, with: animation.animation)
                        self?.treeTable.endUpdates()
                    }
                }
            })
        } else {
            if let indexPaths = manager?.updateExpandForItem(item, expand: true, expandChildren: expandChildren, at: rootIndex, completion: nil), indexPaths.count > 0 {
                if #available(iOS 11, *) {
                    table.performBatchUpdates({
                        table.insertRows(at: indexPaths, with: animation.animation)
                    }, completion: nil)
                } else {
                    table.beginUpdates()
                    table.insertRows(at: indexPaths, with: animation.animation)
                    table.endUpdates()
                }
            }
        }
    }

    /// 收缩指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - foldChildren: 是否收缩子元素
    ///   - indexPath: 根结点下标
    ///   - animation: 动画
    func foldItem(_ item: ZNKTreeItem, foldChildren: Bool, at indexPath: IndexPath, animation: ZNKTreeViewRowAnimation) {
        guard let table = treeTable else { return }
        if item.expand == false {
            return
        }
        if async {
            manager?.updateExpandForItem(item, expand: false, expandChildren: foldChildren, at: indexPath.section, completion: { [weak self] (indexPaths) in
                if let indexPaths = indexPaths {
                    if #available(iOS 11, *) {
                        self?.treeTable.performBatchUpdates({
                            table.deleteRows(at: indexPaths, with: animation.animation)
                        }, completion: nil)
                    } else {
                        self?.treeTable.beginUpdates()
                        table.deleteRows(at: indexPaths, with: animation.animation)
                        self?.treeTable.endUpdates()
                    }
                }
            })
        } else {
            if let indexPaths = manager?.updateExpandForItem(item, expand: false, expandChildren: foldChildren, at: indexPath.section, completion: nil) {
                if #available(iOS 11, *) {
                    table.performBatchUpdates({
                        table.deleteRows(at: indexPaths, with: animation.animation)
                    }, completion: nil)

                } else {
                    table.beginUpdates()
                    table.deleteRows(at: indexPaths, with: animation.animation)
                    table.endUpdates()
                }
            }
        }
    }

    /// 选择指定元素,不会触发didSelect或didDeselect代理方法或者对应通知
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - rootIndex: 根节点下标
    ///   - animated: 动画
    ///   - position: 位置
    func selectItem(_ item: ZNKTreeItem, at indexPath: IndexPath, animated: Bool, position: ZNKTreeViewScrollPosition) {
        guard let table = treeTable, let node = manager?.treeNodeForItem(item, at: indexPath.section), node.expanded == true else { return }
        table.selectRow(at: node.indexPath, animated: animated, scrollPosition: position.position)
    }

    /// 取消选择指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - rootIndex: 根节点下标
    ///   - animated: 动画
    func deselectItem(_ item: ZNKTreeItem, at rootIndex: Int?, animated: Bool) {
        guard let table = treeTable, let node = manager?.treeNodeForItem(item, at: rootIndex), node.expanded == true else { return }
        table.deselectRow(at: node.indexPath, animated: animated)
    }

    /// 移动指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - sourceRootIndex: 源根结点下标
    ///   - targetItem: 目标元素
    ///   - targetRootIndex: 目标根结点下标
    ///   - mode: 插入模式
    func moveItem(_ item: ZNKTreeItem, at sourceindexPath: IndexPath, to targetItem: ZNKTreeItem, at targetIndexPath: IndexPath, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = treeTable, let sourceNode = manager?.treeNodeForItem(item, at: targetIndexPath.section), let targetNode = manager?.treeNodeForItem(targetItem, at: targetIndexPath.section) else { return }
        if (sourceNode.parent != nil && sourceNode.parent?.expanded == false) || (targetNode.parent != nil && targetNode.parent?.expanded == false) {
            return
        }
        table.moveRow(at: sourceNode.indexPath, to: targetNode.indexPath)
        deleteItem(item, at: sourceNode.indexPath.section, animation: animation)
        insertItem(item, in: targetNode.parent?.item, at: targetIndexPath.section, mode: ZNKTreeItemInsertMode.leadingFor(targetItem), animation: animation)
    }


    /// 移动单元格
    ///
    /// - Parameters:
    ///   - sourceIndexPath: 源地址索引
    ///   - targetIndexPath: 目标地址索引
    ///   - animation: 动画
    func moveItem(_ sourceIndexPath: IndexPath, to targetIndexPath: IndexPath, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = treeTable, let sourceNode = manager?.treeNodeForIndexPath(sourceIndexPath), let targetNode = manager?.treeNodeForIndexPath(targetIndexPath)  else { return }
        if (sourceNode.parent != nil && sourceNode.parent?.expanded == false) || (targetNode.parent != nil && targetNode.parent?.expanded == false) {
            return
        }
        table.moveRow(at: sourceIndexPath, to: targetIndexPath)
        deleteItem(sourceNode.item, at: sourceNode.indexPath.section, animation: animation)
        insertItem(sourceNode.item, in: targetNode.parent?.item, at: targetNode.indexPath.section, mode: ZNKTreeItemInsertMode.leadingFor(targetNode.item), animation: animation)
    }

    /// 设置树状图编辑状态，具备动画
    ///
    /// - Parameters:
    ///   - editing: 编辑状态
    ///   - animated: 动画
    func setItemEiditing(_ editing: Bool, animated: Bool) {
        guard let table = treeTable else { return }
        table.setEditing(editing, animated: animated)
    }

}

//MARK: ******************** Private Methods ************************
extension ZNKTreeView {

    /// 展开元素
    ///
    /// - Parameters:
    ///   - treeNode: 元素节点
    ///   - allowDelegate: 允许代理
    fileprivate func expandItemForTreeNode(_ treeNode: ZNKTreeNode, allowsDelegate: Bool = true, at indexPath: IndexPath) {
        if allowsDelegate {
            if let delegate = delegate {
                delegate.treeView(self, willExpandItem: treeNode.item)
            }
        }

        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            if let weakSelf = self {
                if let delegate = weakSelf.delegate, allowsDelegate {
                    DispatchQueue.main.async {
                        delegate.treeView(weakSelf, didExpandItem: treeNode.item)
                    }
                }
            }
        }
        expandItem(treeNode.item, expandChildren: expandChildrenWhenItemExpand, at: indexPath.section, animation: expandAnimation)
        CATransaction.commit()
    }


    fileprivate func foldItemForTreeNode(_ treeNode: ZNKTreeNode, allowsDelegate: Bool = true, at indexPath: IndexPath) {
        guard treeNode.children.count > 0 else {
            return
        }
        if allowsDelegate {
            if let delegate = delegate {
                delegate.treeView(self, willFoldItem: treeNode.item)
            }
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            if let weakSelf = self {
                if let delegate = weakSelf.delegate {
                    DispatchQueue.main.async {
                        delegate.treeView(weakSelf, didFoldItem: treeNode.item)
                    }
                }
            }
        }
        foldItem(treeNode.item, foldChildren: foldChildrenWhenItemFold, at: indexPath, animation: foldAnimation)
        CATransaction.commit()
    }

    /// 批量更新表格
    ///
    /// - Parameters:
    ///   - type: 更新类型
    ///   - indexPaths: 地址索引数组
    ///   - animation: 动画
    fileprivate func batchUpdates(_ type: BatchUpdates, indexPaths: [IndexPath], animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = treeTable, indexPaths.count > 0 else { return }
        if #available(iOS 11, *) {
            table.performBatchUpdates({
                switch type {
                case .insertion:
                    table.insertRows(at: indexPaths, with: animation.animation)
                case .deletion:
                    table.deleteRows(at: indexPaths, with: animation.animation)
                default:
                    break
                }
            }, completion: nil)
        } else {
            table.beginUpdates()
            switch type {
            case .insertion:
                table.insertRows(at: indexPaths, with: animation.animation)
            case .deletion:
                table.deleteRows(at: indexPaths, with: animation.animation)
            default:
                break
            }
            table.endUpdates()
        }

    }
}

//extension ZNKTreeView: UITableViewDataSourcePrefetching {
//
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        if let prefetch = prefetchDataSource {
//            var items: [ZNKTreeItem] = []
//            for indexPath in indexPaths {
//                if let item = manager?.treeNodeForItem(indexPath) {
//                    objc_sync_enter(self)
//                    items.append(item)
//                    objc_sync_exit(self)
//                }
//            }
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//
//    }
//}

//MARK: *************** UITableViewDelegate ****************

extension ZNKTreeView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let manager = manager, let treeNode = manager.treeNodeForIndexPath(indexPath) else { return }
        if let delegate = delegate {
            delegate.treeView(self, didSelect: treeNode.item)
        }
        if treeNode.expanded {
            var treeNodes: [ZNKTreeNode] = []
            var index = treeNode.indexPath.row
            print("deletion current index === ", index)
            manager.visibleChildrenForNode(treeNode, index: &index, nodes: &treeNodes)
            let deletionIndexPaths = treeNodes.compactMap({$0.indexPath})
            print("deletion compactMap indexPath ===> ", deletionIndexPaths)
            treeNode.expanded = false
            if treeNode.parent != nil {
                let rootNode = manager.rootNodeForIndexPath(indexPath)
                var rootIndex: Int = 0
                var roots: [ZNKTreeNode] = []
                rootNode?.visibleTreeNode(&rootIndex, nodes: &roots)
                for root in roots {
                    print("root ++++++ > ", root.indexPath)
                }
            }
            batchUpdates(.deletion, indexPaths: deletionIndexPaths)
        } else {
            var treeNodes: [ZNKTreeNode] = []
            var index = treeNode.indexPath.row
            print("insertion current index === ", index)
            treeNode.expanded = true
            manager.visibleChildrenForNode(treeNode, index: &index, nodes: &treeNodes)
            let deletionIndexPaths = treeNodes.compactMap({$0.indexPath})
            print("insertion compactMap indexPath ===> ", deletionIndexPaths)

            batchUpdates(.insertion, indexPaths: deletionIndexPaths)
        }

        return
        if treeNode.expanded {
            if let delegate = delegate {
                if delegate.treeView(self, canFoldItem: treeNode.item) {
                    foldItemForTreeNode(treeNode, at: indexPath)
                }
            } else {
                foldItemForTreeNode(treeNode, at: indexPath)
            }
        } else {
            if let delegate = delegate {
                if delegate.treeView(self, canExpandItem: treeNode.item) {
                    expandItemForTreeNode(treeNode, at: indexPath)
                }
            } else {
                expandItemForTreeNode(treeNode, at: indexPath)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, heightfor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return 0
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, willDisplay: cell, for: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, willDisplayHeaderView: view, for: section)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, willDisplayFooterView: view, for: section)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didEndDisplaying: cell, for: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, didEndDisplayingHeaderView: view, for: section)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, didEndDisplayingFooterView: view, for: section)
        }
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, heightForHeaderIn: section)
        }
        return 45
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, heightForFooterIn: section)
        }
        return 45
    }



    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, estimatedHeightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return 45
    }


    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, estimatedHeightForHeaderIn: section)
        }
        return 45
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, estimatedHeightForFooterIn: section)
        }
        return 45
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let delegate = delegate {
            return delegate.treeView(self, viewForHeaderIn: section)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let delegate = delegate {
            return delegate.treeView(self, viewForFooterIn: section)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, accessoryButtonTappedFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }



    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldHighlightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didHighlightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didUnhighlightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }


    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let delegate = delegate {
            let node = manager?.treeNodeForIndexPath(indexPath)
            if let _ = delegate.treeView(self, willSelect: node?.item) {
                return node?.indexPath
            }
        }
        return indexPath
    }


    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let delegate = delegate {
            let node = manager?.treeNodeForIndexPath(indexPath)
            if let _ = delegate.treeView(self, willDeselect: node?.item) {
                return node?.indexPath
            }
        }
        return indexPath
    }



    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didDeselect: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }


    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if let delegate = delegate {
            return delegate.treeView(self, editingStyleFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return .none
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if let delegate = delegate {
            return delegate.treeView(self, titleForDeleteConfirmationButtonFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let delegate = delegate {
            return delegate.treeView(self, editActionsFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }


    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let delegate = delegate {
            return delegate.treeView(self, leadingSwipeActionsConfigurationFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let delegate = delegate {
            return delegate.treeView(self, trailingSwipeActionsConfigurationFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldIndentWhileEditingFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return true
    }


    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, willBeginEditingFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }


    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let delegate = delegate {
            if let indexPath = indexPath {
                delegate.treeView(self, didEndEditingFor: manager?.treeNodeForIndexPath(indexPath)?.item)
            } else {
                delegate.treeView(self, didEndEditingFor: nil)
            }
        }
    }


    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if let delegate = delegate {
            let sourceNode = manager?.treeNodeForIndexPath(sourceIndexPath)
            let proposedDestinationNode = manager?.treeNodeForIndexPath(proposedDestinationIndexPath)
            let sourceItem = sourceNode?.item
            let destinationItem = proposedDestinationNode?.item
            if let item = delegate.treeView(self, targetItemForMoveFrom: sourceItem, toProposed: destinationItem) {
                return manager?.treeNodeForItem(item, at: nil)?.indexPath ?? proposedDestinationIndexPath
            }
        }
        return proposedDestinationIndexPath
    }



    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if let delegate = delegate {
            return delegate.treeView(self, indentationLevelFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return 0
    }


    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldShowMenuFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }

    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, canPerformAction: action, for: manager?.treeNodeForIndexPath(indexPath)?.item, withSender: sender)
        }
        return false
    }

    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if let delegate = delegate {
            delegate.treeView(self, performAction: action, for: manager?.treeNodeForIndexPath(indexPath)?.item, with: sender)
        }
    }


    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, canFocus: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldUpdateFocusIn: context)
        }
        return true
    }


    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let delegate = delegate {
            delegate.treeView(self, didUpdateFocusIn: context, with: coordinator)
        }
    }

    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        if let delegate = delegate, let item = delegate.itemForPreferredFocusedView(in: self) {
            return manager?.treeNodeForItem(item, at: nil)?.indexPath
        }
        return nil
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldSpringLoad: manager?.treeNodeForIndexPath(indexPath)?.item, with: context)
        }
        return false
    }

}

//MARK: *************** UITableViewDataSource ****************
extension ZNKTreeView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfRootItemInTreeView(self) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager?.numberOfVisibleNodeAtIndex(section) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataSource?.treeView(self, cellFor: manager?.treeNodeForIndexPath(indexPath)?.item, at: indexPath) ?? .init()
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let dataSource = dataSource {
            dataSource.treeView(self, commit: editingStyle, for: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let dataSource = dataSource {
            return dataSource.treeView(self, canEditFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let dataSource = dataSource {
            return dataSource.treeView(self, titleForHeaderInRootIndex: section)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let dataSource = dataSource {
            return dataSource.treeView(self, titleForFooterInRootIndex: section)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let dataSource = dataSource {
            return dataSource.treeView(self, canMoveFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }



    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let dataSource = dataSource {
            return dataSource.sectionIndexTitles(for: self)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.treeView(self, sectionForSectionIndexTitle: title, at: index)
        }
        return -1
    }



    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let dataSource = dataSource {
            dataSource.treeView(self, moveItemAt: sourceIndexPath, to: destinationIndexPath)
        }
    }
}

extension ZNKTreeView: ZNKTreeNodeControllerDelegate {

    fileprivate func numberOfRootNode() -> Int {
        return dataSource?.numberOfRootItemInTreeView(self) ?? 0
    }

    fileprivate func numberOfChildrenForNode(_ node: ZNKTreeNode?, at rootIndex: Int) -> Int {
        return dataSource?.treeView(self, numberOfChildrenFor: node?.item, at: rootIndex) ?? 0
    }

    fileprivate func treeNode(at childIndex: Int, of node: ZNKTreeNode?, at rootIndex: Int) -> ZNKTreeNode? {
        if let item = dataSource?.treeView(self, childIndex: childIndex, ofItem: node?.item, at: rootIndex) {
            return ZNKTreeNode.init(item: item, parent: node)
        } else {
            return nil
        }
    }

}

extension UITableViewCell {

    /// 关联key
    private struct AssociatedKeys {
        static var buttonName = "cell_expandButton"
    }
    fileprivate var expandButton: UIButton {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.buttonName) as! UIButton
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.buttonName, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    

}
