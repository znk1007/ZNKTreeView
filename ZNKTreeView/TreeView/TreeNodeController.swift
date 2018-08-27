//
//  TreeNodeController.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/11.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

final class TreeNodeController {

    init() {
        appendMutex = .init()
    }
    deinit {
        pthread_mutex_destroy(&appendMutex)
    }

    /// 数据源代理
    var dataSource: TreeNodeControllerDataSource?
    
    /// 树形图数据源
    var rootNodes: [TreeNode] = []

    /// 添加根节点互斥锁
    private var appendMutex: pthread_mutex_t = .init()

    /// 插入指定节点的子节点
    ///
    /// - Parameters:
    ///   - node: 指定节点
    ///   - rootIndex: 根节点下标
    ///   - childIndex: 子节点
    private func insertNode(of node: TreeNode?, in rootIndex: Int) {

        guard let node = node else { return }

        let childNumber = numberOfChildNode(for: node, in: rootIndex)
        guard childNumber != 0 else {
            return
        }
        for i in 0 ..< childNumber {
            if let theNode = dataSource?.treeNode(at: i, of: node, in: rootIndex) {
                insertNode(of: theNode, in: rootIndex)
                node.append(theNode)
            }
        }
    }

    /// 添加根节点
    ///
    /// - Parameter node: 根节点
    private func append(_ node: TreeNode) {
        pthread_mutex_lock(&appendMutex)
        rootNodes.append(node)
        pthread_mutex_unlock(&appendMutex)
    }

    /// 根节点数
    ///
    /// - Returns: 根节点数
    private func numberOfRoot() -> Int {
        return dataSource?.numberOfRootNode ?? 0
    }

    /// 指定节点的子节点数
    ///
    /// - Parameters:
    ///   - node: 指定节点
    ///   - rootIndex: 根节点下标
    /// - Returns: 子节点数
    private func numberOfChildNode(for node: TreeNode?, in rootIndex: Int) -> Int {
        return dataSource?.numberOfChildren(for: node, in: rootIndex) ?? 0
    }

}

// MARK: - 公共方法
extension TreeNodeController {
    /// 加载数据源
    func loadTreeNodes() {
        let rootNumber = numberOfRoot()
        if rootNumber == 0 {
            rootNodes = []
        }
        if rootNodes.count == 0 || rootNodes.count != rootNumber {
            for i in 0 ..< numberOfRoot() {
                if let node = dataSource?.treeNode(at: -1, of: nil, in: i) {
                    node.indexPath = IndexPath.init(row: -1, section: i)
                    self.append(node)
                    self.insertNode(of: node, in: i)
                    //enumericRootNode(node)
                }
            }
        }
    }

    /// 根据指定根结点下标获取根结点
    ///
    /// - Parameter index: 根结点下标
    /// - Returns: 根结点
    func rootNodeFor(_ index: Int) -> TreeNode? {
        guard rootNodes.count > index && index >= 0 else {
            return nil
        }
        return rootNodes[index]
    }

    func enumericRootNode(_ node: TreeNode?) {
        guard let node = node else { return }
        print("++++++++++++++++")
        print("node isExpand ---> ", node.isExpand)
        print("node level ---> ", node.level)
        print("----------------")
        for child in node.children {
            enumericRootNode(child)
        }
    }

    /// 指定根节点下标可见子节点数
    ///
    /// - Parameter rootIndex: 指定根节点
    /// - Returns: 可见子节点数
    func numberOfVisibleNodeIn(_ rootIndex: Int) -> Int {
        guard rootNodes.count > rootIndex else {
            return 0
        }
        let node = rootNodes[rootIndex]
        var nodeIndex: Int = 0
        node.numberOfVisibleNodeInRootIndex(rootIndex, nodeIndex: &nodeIndex)
        return nodeIndex
    }

    /// 根据指定地址索引获取节点
    ///
    /// - Parameter indexPath: 地址索引
    /// - Returns: 节点
    func treeNodeFor(_ indexPath: IndexPath) -> TreeNode? {
        guard rootNodes.count > indexPath.section else {
            return nil
        }
        let rootNode = rootNodes[indexPath.section]
        return rootNode.treeNodeFor(indexPath)
    }

    /// 移动结点
    ///
    /// - Parameters:
    ///   - sourceIndexPath: 原地址索引
    ///   - targetIndexPath: 目标地址索引
    func moveNode(_ sourceIndexPath: IndexPath, targetIndexPath: IndexPath, moveChildren: Bool) -> ([IndexPath], [IndexPath]){
        let sourceSection = sourceIndexPath.section
        let targetSection = targetIndexPath.section
        let sourceRow = sourceIndexPath.row
        let targetRow = sourceIndexPath.row

        if rootNodes.count > sourceSection && rootNodes.count > targetSection {
            if sourceRow < 0 || targetRow < 0 {
                return ([], [])
            }
            guard let sourceNode = treeNodeFor(sourceIndexPath) else { return ([], []) }
            if moveChildren {
                
            } else {

            }
            rootNodes[sourceSection].remove(sourceIndexPath)
            rootNodes[targetSection].insert(sourceNode, at: targetIndexPath)
            rootNodes[sourceSection].resetAllIndexPath()
            rootNodes[targetSection].resetAllIndexPath()
        }
        return ([], [])
    }

}
