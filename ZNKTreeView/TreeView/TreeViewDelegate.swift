//
//  TreeViewDelegate.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/15.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol TreeViewDelegate {

    /// 指定树形图指定元素高度，默认44
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - item: 指定元素
    /// - Returns: 高度
    func treeView(_ treeView: TreeView, heightFor item: Any?, at indexPath: IndexPath) -> CGFloat

    /// 指定树形图段头高度
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - rootIndex: 根元素下标
    /// - Returns: 高度
    func treeView(_ treeView: TreeView, heightForHeaderIn rootIndex: Int) -> CGFloat

    /// 指定树形图段尾高度
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - rootIndex: 根元素下标
    /// - Returns: 高度
    func treeView(_ treeView: TreeView, heightForFooterIn rootIndex: Int) -> CGFloat

    /// 选择指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, didSelect item: Any, at indexPath: IndexPath)

    /// 将要展开指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, willExpand item: Any, at indexPath: IndexPath)

    /// 已展开指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, didExpand item: Any, at indexPath: IndexPath)

    /// 将要收缩指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, willShrink item: Any, at indexPath: IndexPath)

    /// 已收缩指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, didShrink item: Any, at indexPath: IndexPath)


}

extension TreeViewDelegate {
    func treeView(_ treeView: TreeView, heightFor item: Any?, at indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func treeView(_ treeView: TreeView, heightForHeaderIn rootIndex: Int) -> CGFloat {
        return 50
    }

    func treeView(_ treeView: TreeView, heightForFooterIn rootIndex: Int) -> CGFloat {
        return 50
    }

    func treeView(_ treeView: TreeView, didSelect item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, willExpand item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, didExpand item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, willShrink item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, didShrink item: Any, at indexPath: IndexPath) {}
}


