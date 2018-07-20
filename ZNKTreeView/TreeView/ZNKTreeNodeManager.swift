//
//  ZNKTreeNodeManager.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeNodeControllerDelegate {

    /// 段数
    var numberOfSection: Int { get }

    /// 指定段的指定item子item数
    ///
    /// - Parameters:
    ///   - item: <#item description#>
    ///   - section: <#section description#>
    /// - Returns: <#return value description#>
    func numberOfChildrenForItem(_ item: ZNKTreeItem, in section: Int) -> Int
}


final class ZNKTreeNodeController {
    /// 节点数组
    var treeNodes: [ZNKTreeNode] = []

    /// 代理
    var delegate: ZNKTreeNodeControllerDelegate?

    deinit {
        self.delegate = nil
    }

    init() {
        treeNodes = []
    }
}
