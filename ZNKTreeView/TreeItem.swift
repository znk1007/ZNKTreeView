//
//  TreeItem.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/22.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class TreeObject: ZNKTreeItem {
    let name: String
    var children: [TreeObject]

    init(identifier: String, name: String, expand: Bool = true, children: [TreeObject] = []) {
        self.name = name
        self.children = children
        super.init(identifier: identifier, expand: expand)
    }

    func appendChild(_ child: TreeObject) {
        self.children.append(child)
    }
}

extension TreeObject {
    static func initTest(_ completion: (([TreeObject]) -> ())?) {
        DispatchQueue.global().async {
            let grandgrandgrandson1 = TreeObject.init(identifier: "grandgrandgrandson1".randomIdentifier, name: "grandgrandgrandson1".randomIdentifier)
            let grandgrandgrandson2 = TreeObject.init(identifier: "grandgrandgrandson2".randomIdentifier, name: "grandgrandgrandson2".randomIdentifier)
            let grandgrandgrandson3 = TreeObject.init(identifier: "grandgrandgrandson3".randomIdentifier, name: "grandgrandgrandson3".randomIdentifier)
            let grandgrandgrandson4 = TreeObject.init(identifier: "grandgrandgrandson4".randomIdentifier, name: "grandgrandgrandson4".randomIdentifier)
            let grandgrandgrandson5 = TreeObject.init(identifier: "grandgrandgrandson5".randomIdentifier, name: "grandgrandgrandson5".randomIdentifier)

            let grandgrandson1 = TreeObject.init(identifier: "grandgrandson1".randomIdentifier, name: "grandgrandson1".randomIdentifier, children: [grandgrandgrandson1, grandgrandgrandson2, grandgrandgrandson3])
            let grandgrandson2 = TreeObject.init(identifier: "grandgrandson2".randomIdentifier, name: "grandgrandson2".randomIdentifier, children: [grandgrandgrandson4, grandgrandgrandson5])
            let grandgrandson3 = TreeObject.init(identifier: "grandgrandson3".randomIdentifier, name: "grandgrandson3".randomIdentifier, children: [grandgrandgrandson1, grandgrandgrandson3])
            let grandgrandson4 = TreeObject.init(identifier: "grandgrandson4".randomIdentifier, name: "grandgrandson4".randomIdentifier, children: [grandgrandgrandson1, grandgrandgrandson4, grandgrandgrandson2])
            let grandgrandson5 = TreeObject.init(identifier: "grandgrandson5".randomIdentifier, name: "grandgrandson5".randomIdentifier, expand: false, children: [grandgrandgrandson5, grandgrandgrandson1, grandgrandgrandson4])

            let grandson1 = TreeObject.init(identifier: "grandson1".randomIdentifier, name: "grandson1".randomIdentifier, children: [grandgrandson1, grandgrandson5, grandgrandson4, grandgrandson2])
            let grandson2 = TreeObject.init(identifier: "grandson2".randomIdentifier, name: "grandson2".randomIdentifier, children: [grandgrandson2, grandgrandson4, grandgrandson5, grandgrandson3, grandgrandson1])
            let grandson3 = TreeObject.init(identifier: "grandson3".randomIdentifier, name: "grandson3".randomIdentifier, children: [grandgrandson3, grandgrandson4, grandgrandson2])
            let grandson4 = TreeObject.init(identifier: "grandson4".randomIdentifier, name: "grandson4".randomIdentifier, children: [grandgrandson3, grandgrandson5, grandgrandson1])
            let grandson5 = TreeObject.init(identifier: "grandson5".randomIdentifier, name: "grandson5".randomIdentifier, children: [grandgrandson2, grandgrandson1, grandgrandson5])

            let child1 = TreeObject.init(identifier: "child1".randomIdentifier, name: "child1".randomIdentifier, children: [grandson1,/* grandson2, grandson3, grandson4, grandson5*/])
            let child2 = TreeObject.init(identifier: "child2".randomIdentifier, name: "child2".randomIdentifier, children: [/*grandson2, grandson1, grandson5, grandson4, grandson3*/])
            let child3 = TreeObject.init(identifier: "child3".randomIdentifier, name: "child3".randomIdentifier, children: [/*grandson2, grandson1, grandson5, grandson4, grandson3*/])
            let child4 = TreeObject.init(identifier: "child4".randomIdentifier, name: "child4".randomIdentifier, children: [/*grandson5, grandson1, grandson2, grandson4, grandson3*/])
            let child5 = TreeObject.init(identifier: "child5".randomIdentifier, name: "child5".randomIdentifier, children: [/*grandson2, grandson4, grandson3*/])
            let child6 = TreeObject.init(identifier: "child6".randomIdentifier, name: "child6".randomIdentifier, children: [/*grandson2, grandson4, grandson3*/])

            let root1 = TreeObject.init(identifier: "root1".randomIdentifier, name: "root1".randomIdentifier, children: [child1, child2, child3, child4, child5, child6])
            let root2 = TreeObject.init(identifier: "root2".randomIdentifier, name: "root2".randomIdentifier, children: [child4, child5, child6])
            let root3 = TreeObject.init(identifier: "root3".randomIdentifier, name: "root3".randomIdentifier, children: [child4, child5, child6, child1, child2])
            let root4 = TreeObject.init(identifier: "root4".randomIdentifier, name: "root4".randomIdentifier, children: [child5, child6, child4, child5, child6])
            let root5 = TreeObject.init(identifier: "root5".randomIdentifier, name: "root5".randomIdentifier, children: [child3, child4, child5, child6])
            DispatchQueue.main.async {
                completion?([root1, root2,/* root3, root4, root5*/])
            }
        }
    }
}

extension String {
    var randomIdentifier: String {
        return self + String.random(5)
    }

    /// 随机字符串
    ///
    /// - Parameter length: 字符串长度
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


