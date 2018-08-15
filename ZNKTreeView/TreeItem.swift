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
    var children: [TreeItem]
    init(identifier: String = String.random(10), name: String, children: [TreeItem] = []) {
        self.identifier = identifier
        self.name = name
        self.children = children
    }
}

extension TreeItem {

    /// 数据源
    ///
    /// - Parameter completion: 完成回调
    static func fetchData(_ completion: (([TreeItem]) -> ())?) {
        let grandgrandChild1 = TreeItem.init(identifier: "grandgrandChild1", name: "grandgrandChild1")
        let grandgrandChild2 = TreeItem.init(identifier: "grandgrandChild2", name: "grandgrandChild2")
        let grandgrandChild3 = TreeItem.init(identifier: "grandgrandChild3", name: "grandgrandChild3")

        let grandChild1 = TreeItem.init(identifier: "grandChild1", name: "grandChild1", children: [grandgrandChild1])
        let grandChild2 = TreeItem.init(identifier: "grandChild2", name: "grandChild2", children: [grandgrandChild2])
        let grandChild3 = TreeItem.init(identifier: "grandChild3", name: "grandChild3", children: [grandgrandChild3])

        let child1 = TreeItem.init(identifier: "child1", name: "child1", children: [grandChild1])
        let child2 = TreeItem.init(identifier: "child2", name: "child2", children: [grandChild2])
        let child3 = TreeItem.init(identifier: "child3", name: "child3", children: [grandChild3])

        let root1 = TreeItem.init(identifier: "root1", name: "root1", children: [child1])
        let root2 = TreeItem.init(identifier: "root2", name: "root2", children: [child2])
        let root3 = TreeItem.init(identifier: "root3", name: "root3", children: [child3])

        completion?([root1, root2, root3])
    }
}
