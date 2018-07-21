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
    /// 根节点数组
    ///
    /// - Returns: 根节点数组
    func rootNotes() -> [ZNKTreeNode]

    /// 指定段的指定item子item数
    ///
    /// - Parameters:
    ///   - item: 指定item
    ///   - section: 指定段
    /// - Returns: Int
    func numberOfChildrenForNote(_ item: ZNKTreeNode?) -> Int
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
    var delegate: ZNKTreeNodeControllerDelegate? {
        didSet {
            if let del = delegate {
                
            }
        }
    }

    deinit {
        self.delegate = nil
    }

    init() {
        rootTreeNodes = []
        treeNodes = []
    }


}
