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

    init(identifier: String, name: String, expand: Bool = false, children: [TreeObject] = []) {
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
            let grandgrandgrandson1 = TreeObject.init(identifier: "grandgrandgrandson1", name: "grandgrandgrandson1")
            let grandgrandgrandson2 = TreeObject.init(identifier: "grandgrandgrandson2", name: "grandgrandgrandson2")
            let grandgrandgrandson3 = TreeObject.init(identifier: "grandgrandgrandson3", name: "grandgrandgrandson3")
            let grandgrandgrandson4 = TreeObject.init(identifier: "grandgrandgrandson4", name: "grandgrandgrandson4")
            let grandgrandgrandson5 = TreeObject.init(identifier: "grandgrandgrandson5", name: "grandgrandgrandson5")

            let grandgrandson1 = TreeObject.init(identifier: "grandgrandson1", name: "grandgrandson1", children: [grandgrandgrandson1, grandgrandgrandson2, grandgrandgrandson3])
            let grandgrandson2 = TreeObject.init(identifier: "grandgrandson2", name: "grandgrandson2", children: [grandgrandgrandson4, grandgrandgrandson5])
            let grandgrandson3 = TreeObject.init(identifier: "grandgrandson3", name: "grandgrandson3", children: [grandgrandgrandson1, grandgrandgrandson3])
            let grandgrandson4 = TreeObject.init(identifier: "grandgrandson4", name: "grandgrandson4", children: [grandgrandgrandson1, grandgrandgrandson4, grandgrandgrandson2])
            let grandgrandson5 = TreeObject.init(identifier: "grandgrandson5", name: "grandgrandson5", children: [grandgrandgrandson5, grandgrandgrandson1, grandgrandgrandson4])

            let grandson1 = TreeObject.init(identifier: "grandson1", name: "grandson1", children: [grandgrandson1, grandgrandson5, grandgrandson4, grandgrandson2])
            let grandson2 = TreeObject.init(identifier: "grandson2", name: "grandson2", children: [grandgrandson2, grandgrandson4, grandgrandson5, grandgrandson3, grandgrandson1])
            let grandson3 = TreeObject.init(identifier: "grandson3", name: "grandson3", children: [grandgrandson3, grandgrandson4, grandgrandson2])
            let grandson4 = TreeObject.init(identifier: "grandson4", name: "grandson4", children: [grandgrandson3, grandgrandson5, grandgrandson1])
            let grandson5 = TreeObject.init(identifier: "grandson5", name: "grandson5", children: [grandgrandson2, grandgrandson1, grandgrandson5])

            let child1 = TreeObject.init(identifier: "child1", name: "child1", children: [/*grandson1, grandson2, grandson3, grandson4, grandson5*/])
            let child2 = TreeObject.init(identifier: "child2", name: "child2", children: [/*grandson2, grandson1, grandson5, grandson4, grandson3*/])
            let child3 = TreeObject.init(identifier: "child3", name: "child3", children: [/*grandson2, grandson1, grandson5, grandson4, grandson3*/])
            let child4 = TreeObject.init(identifier: "child4", name: "child4", children: [/*grandson5, grandson1, grandson2, grandson4, grandson3*/])
            let child5 = TreeObject.init(identifier: "child5", name: "child5", children: [/*grandson2, grandson4, grandson3*/])
            let child6 = TreeObject.init(identifier: "child6", name: "child6", children: [/*grandson2, grandson4, grandson3*/])

            let root1 = TreeObject.init(identifier: "root1", name: "root1", children: [child1, child2, child3, child4, child5, child6])
            let root2 = TreeObject.init(identifier: "root2", name: "root2", children: [child4, child5, child6])
            let root3 = TreeObject.init(identifier: "root3", name: "root3", children: [child4, child5, child6, child1, child2])
            let root4 = TreeObject.init(identifier: "root4", name: "root4", children: [child5, child6, child4, child5, child6])
            let root5 = TreeObject.init(identifier: "root5", name: "root5", children: [child3, child4, child5, child6])
            DispatchQueue.main.async {
                completion?([root1, root2, root3, root4, root5])
            }
        }
    }
}

