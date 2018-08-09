//
//  ZNKTreeNodeController.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/8.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

final class ZNKTreeNodeController {
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
    /// 节点数组副本集
    private var treeNodeArrayCopy: [ZNKTreeNode] = []
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

    /// 更新所有节点地址索引
    ///
    /// - Parameter index: 根结点下标
    func updateIndexPaths(_ index: Int, specilaNode: ZNKTreeNode?) {
        guard treeNodeArray.count > index else {
            return
        }
        var nodeIndex: Int = 0
        treeNodeArray[index].numberOfVisibleChildrenForRoot(at: index, specilaNode: specilaNode, nodeIndex: &nodeIndex)
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
        return treeNodeArray[section].nodeForIndexPath(indexPath)
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
                let node = ZNKTreeNode.init(item: item, parent: parentNode, indexPath: IndexPath.init(row: -1, section: parentNode.indexPath.section))
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

}

// MARK: - 数据存储
extension ZNKTreeNodeController {
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
    }

    /// 可见节点数
    ///
    /// - Parameter index: 根结点下标
    /// - Returns: 可见节点数
    func numberOfVisibleNodeAtIndex(_ index: Int, specilaNode: ZNKTreeNode?) -> Int {
        guard treeNodeArray.count > index else { return 0 }
        let node = treeNodeArray[index]
        var nodeIndex: Int = 0
        node.numberOfVisibleChildrenForRoot(at: index, specilaNode: specilaNode, nodeIndex: &nodeIndex)
        return nodeIndex
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
                node.append(childNode)
                insertChildNode(of: childNode, at: rootIndex, childIndex: &childIndex)
            }
        }
    }

    private func insertChildNodeCopy(of node: ZNKTreeNode?, at rootIndex: Int, childIndex: inout Int) {

    }
}

//MARK: ********************副本处理*********************

extension ZNKTreeNodeController {

}
