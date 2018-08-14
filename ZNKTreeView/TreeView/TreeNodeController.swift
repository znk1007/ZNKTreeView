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

    /// 加载数据源
    func loadTreeNodes() {
        let rootNumber = numberOfRoot()
        if rootNumber == 0 {
            rootNodes = []
        }
        if rootNodes.count == 0 || rootNodes.count != rootNumber {
            for i in 0 ..< numberOfRoot() {
                if let node = dataSource?.treeNode(at: 0, of: nil, in: i) {
                    var childIndex = 0
                    self.insertNode(of: node, in: i, childIndex: &childIndex)
                    self.append(node)
                }
            }
        }
    }

    /// 插入指定节点的子节点
    ///
    /// - Parameters:
    ///   - node: 指定节点
    ///   - rootIndex: 根节点下标
    ///   - childIndex: 子节点
    private func insertNode(of node: TreeNode?, in rootIndex: Int, childIndex: inout Int) {
        let childNumber = numberOfChildNode(for: node, in: rootIndex)
        guard let node = node else { return }
        guard childNumber != 0 else {
            return
        }
        for i in 0 ..< childNumber {
            if let childNode = dataSource?.treeNode(at: i, of: node, in: rootIndex) {
                
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
