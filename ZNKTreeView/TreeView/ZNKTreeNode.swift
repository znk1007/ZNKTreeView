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

    /// 初始化
    init(item: ZNKTreeItem, parent: ZNKTreeNode?, indexPath: IndexPath) {
        self.parent = parent
        self.item = item
        self.indexPath = indexPath
    }
}
