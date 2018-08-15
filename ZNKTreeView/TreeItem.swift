//
//  TreeItem.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/15.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

extension String {
    /// 随机字符串
    ///
    /// - Parameter length: 长度
    /// - Returns: 随机字符串
    static func random(_ length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0 ..< length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }

        return randomString
    }
}

class TreeItem {
    var identifier: String
    var name: String
    var isExpand: Bool
    var children: [TreeItem]
    init(identifier: String = String.random(10), name: String, isExpand: Bool = false, children: [TreeItem] = []) {
        self.identifier = identifier
        self.name = name
        self.children = children
        self.isExpand = isExpand
    }
}

extension TreeItem {

    /// 数据源
    ///
    /// - Parameter completion: 完成回调
    static func fetchData(_ completion: (([TreeItem]) -> ())?) {
        let grandgrandChild1 = TreeItem.init(name: "grandgrandChild1")
        let grandgrandChild2 = TreeItem.init(name: "grandgrandChild2")
        let grandgrandChild3 = TreeItem.init(name: "grandgrandChild3")

        let grandChild1 = TreeItem.init(name: "grandChild1", children: [grandgrandChild1])
        let grandChild2 = TreeItem.init(name: "grandChild2", children: [grandgrandChild2])
        let grandChild3 = TreeItem.init(name: "grandChild3", children: [grandgrandChild3])

        let child1 = TreeItem.init(name: "child1", children: [grandChild1])
        let child2 = TreeItem.init(name: "child2", children: [grandChild2])
        let child3 = TreeItem.init(name: "child3", children: [grandChild3])

        let root1 = TreeItem.init(name: "root1", children: [child1])
        let root2 = TreeItem.init(name: "root2", children: [child2])
        let root3 = TreeItem.init(name: "root3", children: [child3])

        completion?([root1, root2, root3])
    }
}
