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
            return self.expandHandler?(item) ?? false
        }
        set { }
    }
    /// 数据模型
    let item: ZNKTreeItem
    /// 地址索引
    let indexPath: IndexPath
    /// 节点所处层级
    var level: Int {
        if let p = parent {
            return p.level + 1
        }
        return 0
    }

    /// 展开收缩回调
    private var expandHandler: ((_ item: ZNKTreeItem) -> Bool)?
    /// 初始化
    init(_ item: ZNKTreeItem, parent: ZNKTreeNode?, indexPath: IndexPath, expandHandler: ((_ item: ZNKTreeItem) -> Bool)?) {
        self.parent = parent
        self.item = item
        self.indexPath = indexPath
        self.expandHandler = expandHandler
    }
}
