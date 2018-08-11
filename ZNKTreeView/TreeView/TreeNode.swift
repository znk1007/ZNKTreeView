//
//  TreeNode.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/11.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

final class TreeNode {
    /// 唯一标识
    let identifier: String
    /// 是否展开
    var isExpand: Bool
    /// 任意数据
    let object: Any
    /// 父节点
    let parent: TreeNode?
    /// 子节点数组
    var children: [TreeNode] = []
    /// 地址索引
    var indexPath: IndexPath = .init(row: -1, section: -1)
    /// 控制刷新指定节点下所有可见子节点
    var numberOfVisibleNode: Int = -1
    /// 添加子节点互斥锁
    private var appendMutex: pthread_mutex_t = .init()
    /// 初始化
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识
    ///   - isExpand: 是否展开
    ///   - object: 任意数据
    ///   - parent: 父节点
    ///   - children: 子节点数组
    init(identifier: String, isExpand: Bool, object: Any, parent: TreeNode? = nil, children: [TreeNode] = []) {
        self.identifier = identifier
        self.parent = parent
        self.isExpand = isExpand
        self.object = object
        self.children = children
    }

    /// 指定根节点下可见子节点数
    ///
    /// - Parameters:
    ///   - rootIndex: 指定根节点
    ///   - nodeIndex: 可见子节点数
    func numberOfVisibleNodeInRootIndex(_ rootIndex: Int, nodeIndex: inout Int)  {
        if numberOfVisibleNode == -1 {
            if self.isExpand {
                let number = self.children.count
                for _ in 0 ..< number {
                    nodeIndex += 1
                    self.indexPath = IndexPath.init(row: nodeIndex, section: rootIndex)
                }
                for child in self.children {
                    child.numberOfVisibleNodeInRootIndex(rootIndex, nodeIndex: &nodeIndex)
                }
                numberOfVisibleNode = nodeIndex
            }
        }
        nodeIndex = numberOfVisibleNode
    }

    /// 添加子节点
    ///
    /// - Parameter node: 子节点
    func append(_ node: TreeNode) {

    }

    func remove(<#parameters#>) -> <#return type#> {
        <#function body#>
    }

}
