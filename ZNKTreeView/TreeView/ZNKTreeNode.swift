//
//  ZNKTreeNode.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/7/19.
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
        set { item.expand = newValue }
    }
    /// 地址索引
    let indexPath: IndexPath
    /// 数据源
    let item: ZNKTreeItem
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
                var visibelNumber = self.children.count
                for child in self.children {
                    visibelNumber += child.numberOfVisibleChildren
                }
                return visibelNumber
            } else {
                return 0
            }
        }
    }
    /// 初始化
    ///
    /// - Parameters:
    ///   - item: 数据源
    ///   - parent: 父节点
    ///   - children: 子节点数组
    ///   - indexPath: 地址索引
    init(item: ZNKTreeItem, parent: ZNKTreeNode?, children: [ZNKTreeNode] = [], indexPath: IndexPath) {
        self.parent = parent
        self.item = item
        self.indexPath = indexPath
        self.children = children
    }

    /// 添加子节点
    ///
    /// - Parameter child: 子节点
    func append(_ child: ZNKTreeNode) {
        children = children.filter({$0.item.identifier != child.item.identifier})
        children.append(child)
    }

}
