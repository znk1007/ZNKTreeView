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
    var object: Any
    /// 父节点
    let parent: TreeNode?
    /// 子节点数组
    var children: [TreeNode] = []
    /// 地址索引
    var indexPath: IndexPath = .init(row: -1, section: -1)
    /// 添加子节点互斥锁
    private var appendMutex: pthread_mutex_t = .init()
    /// 收缩互斥锁
    private var shrinkMutex: pthread_mutex_t = .init()
    /// 展开互斥锁
    private var expandMutex: pthread_mutex_t = .init()
    /// 可见节点数
    private var numberOfVisibleNode: Int = -1

    deinit {
        pthread_mutex_destroy(&appendMutex)
        pthread_mutex_destroy(&shrinkMutex)
        pthread_mutex_destroy(&expandMutex)
    }

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
        shrinkMutex = .init()
        expandMutex = .init()
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
                    child.numberOfVisibleNodeInRootIndex(rootIndex, nodeIndex: &nodeIndex)
                }
                numberOfVisibleNode = nodeIndex
            }
        } else {
            nodeIndex = numberOfVisibleNode
        }
    }

    /// 重置所有子节点的地址索引
    func resetAllIndexPath() {
        self.numberOfVisibleNode = -1
        for child in self.children {
            child.indexPath = IndexPath.init(row: -1, section: self.indexPath.section)
            child.resetAllIndexPath()
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

    /// 所有可见子节点的地址索引
    ///
    /// - Parameter indexPaths: 地址索引数组
    func shrinkVisibleChildIndexPath(_ indexPaths: inout [IndexPath]) {
        if self.isExpand {
            for child in self.children {
                pthread_mutex_lock(&shrinkMutex)
                indexPaths.append(child.indexPath)
                pthread_mutex_unlock(&shrinkMutex)
                child.shrinkVisibleChildIndexPath(&indexPaths)
            }
        }
    }

    /// 展开指定节点的子节点
    ///
    /// - Parameters:
    ///   - nodeIndex: 节点下标
    ///   - indexPaths: 地址索引数组
    func expandVisibleChildIndexPath(_ nodeIndex: inout Int, indexPaths: inout [IndexPath]) {
        if self.isExpand {
            for child in self.children {
                nodeIndex += 1
                let indexPath = IndexPath.init(row: nodeIndex, section: self.indexPath.section)
                pthread_mutex_lock(&expandMutex)
                indexPaths.append(indexPath)
                pthread_mutex_unlock(&expandMutex)
                child.indexPath = indexPath
                child.expandVisibleChildIndexPath(&nodeIndex, indexPaths: &indexPaths)
            }
        }
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

    /// 指定的地址索引插入结点
    ///
    /// - Parameters:
    ///   - node: 结点
    ///   - indexPath: 地址索引
    func insert(_ node: TreeNode, at indexPath: IndexPath) {
        for child in self.children {
            if let index = self.children.index(where: {$0.indexPath.compare(indexPath) == .orderedSame}) {
                self.children.insert(node, at: index)
            }
            child.insert(node, at: indexPath)
        }
    }

    /// 更新节点元素值
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - object: 元素
    func update(_ indexPath: IndexPath, object: Any) {
        for child in self.children {
            if let index = self.children.index(where: {$0.indexPath.compare(indexPath) == .orderedSame}) {
                self.children[index].object = object
            }
            child.update(indexPath, object: object)
        }
    }

    /// 删除指定地址索引节点
    ///
    /// - Parameter indexPath: 地址索引
    func remove(_ indexPath: IndexPath) {
        for child in self.children {
            if let index = self.children.index(where: {$0.indexPath.compare(indexPath) == .orderedSame}) {
                self.children.remove(at: index)
            }
            child.remove(indexPath)
        }
    }

    /// 更新子节点展开状态
    ///
    /// - Parameter expand: 是否展开
    func updateExpand(_ expand: Bool) {
        for child in self.children {
            if child.children.count > 0 {
                child.isExpand = expand
            }
            child.updateExpand(expand)
        }
    }
}
