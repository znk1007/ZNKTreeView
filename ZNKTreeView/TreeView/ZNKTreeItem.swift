//
//  ZNKTreeItem.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/19.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

/// 树数据模型
class ZNKTreeItem {

    /// 唯一标识
    let identifier: String
    /// 数据源
    let item: Any
    /// 索引
    let indexPath: IndexPath
    init(identifier: String, indexPath: IndexPath, item: Any) {
        self.identifier = identifier
        self.indexPath = indexPath
        self.item = item
    }
}
