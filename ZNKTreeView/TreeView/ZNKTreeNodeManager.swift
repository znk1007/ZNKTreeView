//
//  ZNKTreeNodeManager.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

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
    func numberOfChildreForNode(_ node: ZNKTreeNode?, atRootIndex index: Int) -> Int

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


final class ZNKTreeNodeController {
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
    private func rootTreeNodes() -> [ZNKTreeNode] {
        for i in 0 ..< numberOfRoot() {
            pthread_mutex_lock(&rootMutex)
            if let node = delegate?.treeNode(at: -1, of: nil, atRootIndex: i) {
                append(node)
            }
            pthread_mutex_unlock(&rootMutex)
        }
        return treeNodes
    }



    /// 某个节点子节点数
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - index: 节点下标
    /// - Returns: 子节点数
    private func numberOfChildNode(for node: ZNKTreeNode?, rootIndex: Int) -> Int {
        return delegate?.numberOfChildreForNode(node, atRootIndex: rootIndex) ?? 0
    }

    /// 某节点的子节点数组
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - rootIndex: 跟节点下标
    private func children(of node: ZNKTreeNode?, at rootIndex: Int) -> [ZNKTreeNode] {
        var newNode = node
        let rootNodes = rootTreeNodes()
        if newNode == nil {
            if rootNodes.count - 1 < rootIndex {
                return []
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
        return newNode?.children ?? []
    }

    /// 添加结点
    ///
    /// - Parameter root: 根结点
    private func append(_ child: ZNKTreeNode) {
        treeNodes = treeNodes.filter({$0.item.identifier != child.item.identifier})
    }

}
