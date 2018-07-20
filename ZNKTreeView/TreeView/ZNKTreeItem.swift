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
    /// 初始化

    /// 初始化
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识
    ///   - indexPath: 地址索引
    ///   - item: 项目
    init(identifier: String, indexPath: IndexPath, item: Any) {
        self.identifier = identifier
        self.indexPath = indexPath
        self.item = item
    }

    /// 快捷初始化
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识 “rootNote”
    ///   - indexPath: 地址索引 IndexPath.init(row: 0, section: 0)
    ///   - item: 项目 []
    convenience init() {
        self.init(identifier: "rootNote", indexPath: IndexPath.init(row: 0, section: 0), item: [])
    }
}
