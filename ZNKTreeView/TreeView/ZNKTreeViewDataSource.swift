//
//  ZNKTreeViewDataSource.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/8.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeViewDataSource {

    /// 表格根节点数 默认1
    ///
    /// - Parameter treeView: 表格
    /// - Returns: 根节点数
    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int

    /// 每段指定ZNKTreeItem子行数
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    ///   - index: 指定段下标
    /// - Returns: 行数
    func treeView(_ treeView: ZNKTreeView, numberOfChildrenFor item: ZNKTreeItem?, at rootIndex: Int) -> Int

    /// 树形图每段每行数据源元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - child: 子节点下标
    ///   - item: 数据源
    ///   - root: 根结点下标
    /// - Returns: 数据源
    func treeView(_ treeView: ZNKTreeView, childIndex child: Int, ofItem item: ZNKTreeItem?, at rootIndex: Int) -> ZNKTreeItem?

    /// 数据源展示单元格
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 展示数据源
    /// - Returns: UITableViewCell
    func treeView(_ treeView: ZNKTreeView, cellFor item: ZNKTreeItem?, at indexPath: IndexPath) -> UITableViewCell

    /// 编辑item
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - editingStyle: 编辑类型
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, commit editingStyle: UITableViewCellEditingStyle, for item: ZNKTreeItem?)

    /// item是否可以编辑
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canEditFor item: ZNKTreeItem?) -> Bool

    /// 段头标题
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - index: 根结点下标
    /// - Returns: 标题
    func treeView(_ treeView: ZNKTreeView, titleForHeaderInRootIndex index: Int) -> String?

    /// 段尾标题
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - index: 根结点下标
    /// - Returns: 标题
    func treeView(_ treeView: ZNKTreeView, titleForFooterInRootIndex index: Int) -> String?

    /// 是否可移动ZNKTreeItem
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canMoveFor item: ZNKTreeItem?) -> Bool

    /// 索引数组
    ///
    /// - Parameter treeView: ZNKTreeView
    /// - Returns: 索引数组
    func sectionIndexTitles(for treeView: ZNKTreeView) -> [String]?

    /// 索引所在的位置
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - title: 标题
    ///   - index: 下标
    /// - Returns: 位置
    func treeView(_ treeView: ZNKTreeView, sectionForSectionIndexTitle title: String, at index: Int) -> Int

    /// 将item从源地址索引移动到目标地址索引
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - sourceIndexPath: 源地址索引
    ///   - destinationIndexPath: 目标地址索引
    func treeView(_ treeView: ZNKTreeView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
}

extension ZNKTreeViewDataSource {

    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int {
        return 1
    }
    func treeView(_ treeView: ZNKTreeView, commit editingStyle: UITableViewCellEditingStyle, for item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, canEditFor item: ZNKTreeItem?) -> Bool { return false }
    func treeView(_ treeView: ZNKTreeView, titleForHeaderInRootIndex index: Int) -> String? { return nil }
    func treeView(_ treeView: ZNKTreeView, titleForFooterInRootIndex index: Int) -> String? { return nil }
    func treeView(_ treeView: ZNKTreeView, canMoveFor item: ZNKTreeItem?) -> Bool { return false }
    func sectionIndexTitles(for treeView: ZNKTreeView) -> [String]? { return nil }
    func treeView(_ treeView: ZNKTreeView, sectionForSectionIndexTitle title: String, at index: Int) -> Int { return -1 }
    func treeView(_ treeView: ZNKTreeView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {}
}
