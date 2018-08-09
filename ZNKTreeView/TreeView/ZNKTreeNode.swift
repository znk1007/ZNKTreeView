//
//  ZNKTreeNode.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/8.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

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



    /// 插入数据互斥锁
    private var insertMutex: pthread_mutex_t
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
    }

    deinit {
        pthread_mutex_destroy(&insertMutex)
    }

    /// 指定根结点可见子节点数
    ///
    /// - Parameter index: 根结点
    /// - Returns: 可见子节点数
    func numberOfVisibleChildrenForRoot(at index: Int, specilaNode: ZNKTreeNode?, nodeIndex: inout Int) {
        if self.parent == nil || self.parent?.expanded == true {
            if let specialNode = specilaNode {

            }
            self.indexPath = IndexPath.init(row: nodeIndex, section: index)
            nodeIndex += 1
            for child in self.children {
                child.numberOfVisibleChildrenForRoot(at: index, specilaNode: specilaNode, nodeIndex: &nodeIndex)
            }
        } else {
            self.indexPath = IndexPath.init(row: -1, section: index)
        }
    }

    func updateChildrenIndexPath(_ index: Int)  {
        
    }

    /// 可见节点，仅限展开收缩时使用
    ///
    /// - Parameters:
    ///   - index: 下标
    ///   - nodes: 节点数组
    func visibleTreeNode(_ nodeIndex: inout Int, nodes: inout [ZNKTreeNode]) {
        if self.expanded == true {
            if let parent = self.parent {
                nodeIndex = self.indexPath.row
//                nodeIndex += 1
                print("child parent index 1 ===> ", nodeIndex)
                self.indexPath = IndexPath.init(row: nodeIndex, section: self.indexPath.section)
            }
            for child in self.children {
                nodeIndex += 1
                print("child parent index 2 ===> ", nodeIndex)
                child.indexPath = IndexPath.init(row: nodeIndex, section: child.indexPath.section)
                nodes.append(child)
                child.visibleTreeNode(&nodeIndex, nodes: &nodes)
            }
        }
    }

    /// 更新子节点的展开状态
    ///
    /// - Parameter expand: 是否展开
    func updateChildrenExpand(_ expand: Bool) {
        for child in self.children where child.children.count > 0 {
            child.expanded = expand
            child.updateChildrenExpand(expand)
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
        if self.indexPath.compare(indexPath) == .orderedSame {
            return self
        }
        for child in self.children {
            if let childItem =  child.nodeForIndexPath(indexPath) {
                return childItem
            }
        }
        return nil
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
