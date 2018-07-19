//
//  ZNKTreeNode.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/7/19.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

final class ZNKTreeNode {
    /// 是否展开
    var expand: Bool {
        get {
            return self.expandHandler?(innerItem) ?? false
        }
        set { }
    }
    /// 数据模型
    let innerItem: ZNKTreeItem
    /// 展开收缩回调
    private var expandHandler: ((_ item: ZNKTreeItem) -> Bool)?
    /// 初始化
    init(_ item: ZNKTreeItem, expandHandler: ((_ item: ZNKTreeItem) -> Bool)?) {
        self.innerItem = item
        self.expandHandler = expandHandler
    }
}
