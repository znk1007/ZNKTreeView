//
//  TreeNodeControllerDataSource.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/12.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol TreeNodeControllerDataSource {
    /// 根节点数
    var numberOfRootNode: Int { get }

    /// 指定根节点下指定节点的子节点数
    ///
    /// - Parameters:
    ///   - node: 指定节点
    ///   - rootIndex: 根节点
    /// - Returns: 子节点数
    func numberOfChildren(for node: TreeNode?, in rootIndex: Int) -> Int

    /// 树形图节点数据源
    ///
    /// - Parameters:
    ///   - childIndex: 子节点下标
    ///   - node: 节点
    ///   - rootIndex: 根节点下标
    /// - Returns: 节点数据源
    func treeNode(at childIndex: Int, of node: TreeNode?, in rootIndex: Int) -> TreeNode?

    
}

extension TreeNodeControllerDataSource {
    var numberOfRootNode: Int {
        get { return 0 }
    }


}
