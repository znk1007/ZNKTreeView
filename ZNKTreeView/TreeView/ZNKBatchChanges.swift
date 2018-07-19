//
//  ZNKBatchChanges.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/19.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

/// 批量处理对象
fileprivate class ZNKBatchChangeObject {
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
    let ranking: IndexPath
    /// 更新回调
    let updates:(() -> ())
    init(_ type: ZNKBatchChangeType, ranking: IndexPath, updates: @escaping (() -> ())) {
        self.type = type
        self.ranking = ranking
        self.updates = updates
    }

    /// 比较两个批量处理实例对象
    ///
    /// - Parameter other: 比较源对象
    /// - Returns: ComparisonResult
    func compare(_ other: ZNKBatchChangeObject) -> ComparisonResult {
        if self.isDestructive {
            if !other.isDestructive {
                return .orderedAscending
            } else {
                return other.ranking.compare(self.ranking)
            }
        } else if self.type == .move && other.type != .move {
            return other.isDestructive ? .orderedAscending : .orderedDescending
        } else if self.isContructive {
            if !other.isContructive {
                return .orderedDescending
            } else {
                return self.ranking.compare(other.ranking)
            }
        } else {
            return .orderedSame
        }
    }

    /// 是否删除
    private var isDestructive: Bool {
        return self.type == .collapse || self.type == .deletion
    }

    /// 是否为创建
    private var isContructive: Bool {
        return self.type == .expansion || self.type == .insertion
    }
}

final class ZNKBatchChanges {

    /// 批量操作数
    private var batchChangesCounter: Int = 0

    /// 批量操作实体数组
    private var operations: [ZNKBatchChangeObject] = []

    init() {
        batchChangesCounter = 0
    }

    /// 开始批量处理
    func beginUpdates() {
        batchChangesCounter += 1
        if batchChangesCounter == 0 {
            operations = []
        }
    }

    /// 结束批量处理
    func endUpdates() {
        batchChangesCounter -= 1
        if batchChangesCounter == 0 {
            operations.sort { (obj1, obj2) -> Bool in
                return obj1.compare(obj2) == .orderedAscending
            }
            for object in operations {
                object.updates()
            }
            operations.removeAll()
        }
    }

    /// 展开item
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - updates: 更新回调
    func expandItem(at indexPath: IndexPath, updates: @escaping (() -> ())) {
        let object = ZNKBatchChangeObject.init(.expansion, ranking: indexPath, updates: updates)
        self.addBatchChangeObject(object)
    }

    /// 插入item
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - updates: 更新回调
    func insertItem(at indexPath: IndexPath, updates: @escaping (() -> ())) {
        let object = ZNKBatchChangeObject.init(.insertion, ranking: indexPath, updates: updates)
        self.addBatchChangeObject(object)
    }

    /// 收缩item
    ///
    /// - Parameters:
    ///   - indexPath: 地址索引
    ///   - updates: 更新回调
    func collapseItem(at indexPath: IndexPath, updates: @escaping (() -> ())) {
        let object = ZNKBatchChangeObject.init(.collapse, ranking: indexPath, updates: updates)
        self.addBatchChangeObject(object)
    }

    /// 移动item
    ///
    /// - Parameters:
    ///   - formIndexPath: 起始地址索引
    ///   - formUpdates: 起始更新回调
    ///   - toIndexPath: 目标地址索引
    ///   - toUpdates: 目标更新回调
    func moveItem(from fromIndexPath: IndexPath, fromUpdates: @escaping (() -> ()), to toIndexPath: IndexPath, toUpdates: @escaping (() -> ())) {
        let fromObject = ZNKBatchChangeObject.init(.deletion, ranking: fromIndexPath, updates: fromUpdates)
        let toObject = ZNKBatchChangeObject.init(.insertion, ranking: toIndexPath, updates: toUpdates)
        self.addBatchChangeObject(fromObject)
        self.addBatchChangeObject(toObject)
    }

    /// 添加批量处理实例
    ///
    /// - Parameter object: 实例对象
    private func addBatchChangeObject(_ object: ZNKBatchChangeObject) {
        if batchChangesCounter > 0 {
            operations.append(object)
        } else {
            object.updates()
        }
    }
}
