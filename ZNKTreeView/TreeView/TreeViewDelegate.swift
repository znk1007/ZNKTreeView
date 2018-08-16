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
    func treeView(_ treeView: TreeView, heightFor item: Any?) -> CGFloat
}

extension TreeViewDelegate {
    func treeView(_ treeView: TreeView, heightFor item: Any?) -> CGFloat {
        return 44
    }
}
