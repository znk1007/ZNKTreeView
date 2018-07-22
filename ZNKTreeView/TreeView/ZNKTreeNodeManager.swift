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
    func numberOfRootNode() -> Int

    /// 指定段的指定节点子节点数
    ///
    /// - Parameters:
    ///   - item: 指定item
    ///   - section: 指定段
    /// - Returns: Int
    func numberOfChildreForNode(_ node: ZNKTreeNode?, atRootIndex index: Int) -> Int

    /// 树形图每个节点的数据源
    ///
    /// - Parameters:
    ///   - childIndex: 子节点下标
    ///   - node: 节点
    ///   - index: 根结点下标
    ///   - expandHandler: 展开回调
    /// - Returns: 节点
    func treeNode(at childIndex: Int, of node: ZNKTreeNode?, atRootIndex index: Int, expandHandler: ((ZNKTreeNode) -> Bool)?) -> ZNKTreeNode?
}

extension ZNKTreeNodeControllerDelegate {

    /// 默认实现
    ///
    /// - Returns: 1
    func numberOfRootNode() -> Int {
        return 1
    }

}


final class ZNKTreeNodeController {
    /// 根结点数组
    private var rootNodes: [ZNKTreeNode] = []
    /// 节点数组
    private var nodes: [ZNKTreeNode] = []
    /// 代理
    var delegate: ZNKTreeNodeControllerDelegate?

    deinit {
        self.delegate = nil
    }

    init() {
        rootNodes = []
        nodes = []
    }

    /// 根结点数
    ///
    /// - Returns: 根结点数
    private func numberOfRoot() -> Int {
        return delegate?.numberOfRootNode() ?? 0
    }

    /// 获取根结点
    ///
    /// - Returns: 根结点数组
    private func rootTreeNodes() {
        rootNodes = []
        for i in 0 ..< numberOfRoot() {
            if let node = delegate?.treeNode(at: -1, of: nil, atRootIndex: i, expandHandler: { (_) -> Bool in
                return true
            }) {
                rootNodes.append(node)
            }
        }
    }



    private func treeNodes() {
        for i in 0 ..< numberOfRoot() {
            let rootNode = rootNodes[i]
            let childNumber = self.numberOfChildNode(for: rootNode, index: i)
            for j in 0 ..< childNumber {
                let node = delegate?.treeNode(at: j, of: rootNode, atRootIndex: i, expandHandler: { (_) -> Bool in
                    return true
                })
            }
        }
    }

    /// 某个节点子节点数
    ///
    /// - Parameters:
    ///   - node: 节点
    ///   - index: 节点下标
    /// - Returns: 子节点数
    private func numberOfChildNode(for node: ZNKTreeNode?, index: Int) -> Int {
        return delegate?.numberOfChildreForNode(node, atRootIndex: index) ?? 0
    }


    private func childNode(at childIndex: Int, of node: ZNKTreeNode?, at rootIndex: Int) {
        
    }

}
