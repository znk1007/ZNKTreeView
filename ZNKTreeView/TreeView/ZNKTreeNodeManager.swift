//
//  ZNKTreeNodeManager.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeNodeControllerDelegate {

    /// 根节点数组
    var roomItems: [ZNKTreeItem] { get }

    /// 指定段的指定item子item数
    ///
    /// - Parameters:
    ///   - item: 指定item
    ///   - section: 指定段
    /// - Returns: Int
    func numberOfChildrenForItem(_ item: ZNKTreeItem, in section: Int) -> Int
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
                let items = del.roomItems
                let nodes = items.map({ZNKTreeNode.init($0, parent: nil, indexPath: $0.indexPath, expandHandler: { (_) -> Bool in
                    return true
                })})
                rootTreeNodes.append(contentsOf: nodes)
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
