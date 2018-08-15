//
//  TreeViewDataSource.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/15.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol TreeViewDataSource {

    /// 指定树形图根元素数
    ///
    /// - Parameter treeView: 指定树形图
    /// - Returns: 根元素数
    func numberOfRootItem(in treeView: TreeView) -> Int

    /// 在指定树形图中，根据指定的元素和指定根结点下标返回子元素数
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - item: 指定元素
    ///   - rootIndex: 指定根结点下标
    /// - Returns: 子元素数
    func treeView(_ treeView: TreeView, numberOfChildFor item: Any?, In rootIndex: Int) -> Int

    /// 在指定树形图中根据指定的子元素下标和唯一标识获取子元素数据
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - childIndex: 子节点下标
    ///   - identifier: 唯一标识
    /// - Returns: 子节点数据
    func treeView(_ treeView: TreeView, childIndex: Int, for item: Any?, in rootIndex: Int) -> (Any?, String?)

    /// 根据指定树形图的元素和地址索引，返回指定的单元格
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - item: 指定元素
    ///   - indexPath: 指定地址索引
    /// - Returns: 单元格
    func treeView(_ treeView: TreeView, cellFor item: Any, at indexPath: IndexPath) -> UITableViewCell
}

extension TreeViewDataSource {
    func numberOfRootItem(in treeView: TreeView) -> Int {
        return 0
    }
}
