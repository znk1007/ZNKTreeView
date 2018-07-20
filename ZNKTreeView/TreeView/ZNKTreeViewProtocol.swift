//
//  ZNKTreeViewProtocol.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeViewDelete {

}

protocol ZNKTreeViewDataSource {


    /// 根节点
    ///
    /// - Parameter treeView: ZNKTreeView
    /// - Returns: 根节点数组
    func rootItemsInTreeView(_ treeView: ZNKTreeView) -> [ZNKTreeItem]

    /// 每段指定ZNKTreeItem子行数
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    ///   - section: 指定段
    /// - Returns: 行数
    func treeView(_ treeView: ZNKTreeView, numberOfChildrenForItem item: ZNKTreeItem, in section: Int) -> Int
}

extension ZNKTreeViewDataSource {

    /// 默认实现
    ///
    /// - Parameter treeView: ZNKTreeView
    /// - Returns: [ZNKTreeItem]
    func rootItemsInTreeView(_ treeView: ZNKTreeView) -> [ZNKTreeItem] {
        let item = ZNKTreeItem.init()
        let rootTreeNode = ZNKTreeNode.init(item, parent: nil, indexPath: item.indexPath) { (_) -> Bool in
            return true
        }
        return [rootTreeNode.item]
    }

}


