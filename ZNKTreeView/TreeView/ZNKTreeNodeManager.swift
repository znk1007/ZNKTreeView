//
//  ZNKTreeNodeManager.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeNodeControllerDelegate {
    var numberOfSection: Int { get }

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
