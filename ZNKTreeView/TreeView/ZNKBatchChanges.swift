//
//  ZNKBatchChanges.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/19.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

/// 批量处理对象
final class ZNKBatchChangeObject {
    /// 批量改变类型
    ///
    /// - insertion: 插入
    /// - expansion: 展开
    /// - deletion: 删除
    /// - collapse: 收起
    /// - move: 移动
    enum ZNKBatchChangeType {
        case insertion
        case expansion
        case deletion
        case collapse
        case move
    }

    /// 处理类型
    let type: ZNKBatchChangeType
    /// 排序
    let ranking: Int
    /// 更新回调
    let updates:(() -> ())
    init(_ type: ZNKBatchChangeType, ranking: Int, updates: @escaping (() -> ())) {
        self.type = type
        self.ranking = ranking
        self.updates = updates
    }

    func compare(_ object: ZNKBatchChangeObject) -> ComparisonResult {
        
    }
}

final class ZNKBatchChanges {
    func beginUpdates() {

    }

    func endUpdates() {

    }
}
