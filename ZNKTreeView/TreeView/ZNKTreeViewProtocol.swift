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
    func treeView(_ treeView: ZNKTreeView, numberOfChildrenForItem item: ZNKTreeItem, atRootItemIndex index: Int) -> Int

//    func treeView(_ treeView: ZNKTreeView, childIndexPath indexPath: IndexPath, ofItem item: ZNKTreeItem?) -> ZNKTreeItem
}

extension ZNKTreeViewDataSource {

    func numberOfRootItemInTreeView(_ treeView: ZNKTreeView) -> Int {
        return 1
    }
}


