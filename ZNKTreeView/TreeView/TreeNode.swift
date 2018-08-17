//
//  TreeNode.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/11.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

final class TreeNode {
    /// 是否展开
    var isExpand: Bool
    /// 节点层级
    var level: Int {
        get {
            if let parent = parent {
                return parent.level + 1
            } else {
                return 0
            }
        }
    }
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
    init(object: Any, isExpand: Bool, parent: TreeNode?, children: [TreeNode] = []) {
        self.parent = parent
        self.isExpand = isExpand
        self.object = object
        self.children = children
        appendMutex = .init()
    }

    /// 指定根节点下可见子节点数
    ///
    /// - Parameters:
    ///   - rootIndex: 指定根节点
    ///   - nodeIndex: 可见子节点数
    func numberOfVisibleNodeInRootIndex(_ rootIndex: Int, nodeIndex: inout Int)  {
        if numberOfVisibleNode == -1 {
            if self.isExpand {
                for child in self.children {
                    child.indexPath = IndexPath.init(row: nodeIndex, section: rootIndex)
                    nodeIndex += 1
                    print("self indexPath ---> ", child.indexPath)
                    child.numberOfVisibleNodeInRootIndex(rootIndex, nodeIndex: &nodeIndex)
                }
                numberOfVisibleNode = nodeIndex
            }
        } else {
            nodeIndex = numberOfVisibleNode
        }
    }

    /// 根据地址索引获取节点
    ///
    /// - Parameter indexPath: 地址索引
    /// - Returns: 节点
    func treeNodeFor(_ indexPath: IndexPath) -> TreeNode? {
        if self.indexPath.compare(indexPath) == .orderedSame {
            return self
        }
        for child in self.children {
            if let node = child.treeNodeFor(indexPath) {
                return node
            }
        }
        return nil
    }

    /// 添加子节点
    ///
    /// - Parameter node: 子节点
    func append(_ node: TreeNode) {
        pthread_mutex_lock(&appendMutex)
        self.children.append(node)
        pthread_mutex_unlock(&appendMutex)
    }

    /// 删除子节点
    ///
    /// - Parameter node: 子节点
    func remove(_ node: TreeNode) {
        for child in self.children {
            if let index = self.children.index(where: {$0.indexPath.compare(node.indexPath) == .orderedSame}) {
                self.children.remove(at: index)
            }
            child.remove(node)
        }
    }
}
