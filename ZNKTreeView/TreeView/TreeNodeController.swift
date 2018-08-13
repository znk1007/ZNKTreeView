//
//  TreeNodeController.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/11.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

final class TreeNodeController {

    /// 数据源代理
    var dataSource: TreeNodeControllerDataSource?

    /// 树形图数据源
    var rootNodes: [TreeNode] = []

    /// 加载数据源
    func loadTreeNodes() {
        let rootNumber = numberOfRoot()
        if rootNumber == 0 {
            rootNodes = []
        }
        if rootNodes.count == 0 || rootNodes.count != rootNumber {
            for i in 0 ..< numberOfRoot() {
                if let node = dataSource?.treeNode(at: 0, of: nil, in: i) {
                    node.indexPath = IndexPath.init(row: 0, section: i)
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
    private func numberOfChildNode(for node: TreeNode, in rootIndex: Int) -> Int {
        return dataSource?.numberOfChildren(for: node, in: rootIndex) ?? 0
    }

}
