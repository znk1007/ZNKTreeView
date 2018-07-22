//
//  ZNKTreeNodeManager.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeNodeControllerDelegate {

    /// 根节点数
    ///
    /// - Returns: 根节点数
    func numberOfRootItem() -> Int

    /// 指定段的指定item子item数
    ///
    /// - Parameters:
    ///   - item: 指定item
    ///   - section: 指定段
    /// - Returns: Int
    func numberOfChildreForNode(_ node: ZNKTreeNode?, atRootIndex index: Int) -> Int
}

extension ZNKTreeNodeControllerDelegate {

    /// 默认实现
    ///
    /// - Returns: 1
    func numberOfRootItem() -> Int {
        return 1
    }

}


final class ZNKTreeNodeController {

    /// 根节点数组
    var rootTreeNodes: [ZNKTreeNode] = []

    /// 节点数组
    var treeNodes: [ZNKTreeNode] = []

    /// 代理
    var delegate: ZNKTreeNodeControllerDelegate?

    deinit {
        self.delegate = nil
    }

    init() {
        rootTreeNodes = []
        treeNodes = []
    }


}
