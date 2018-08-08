//
//  ZNKTreeItem.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/8.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class ZNKTreeItem {

    /// 唯一标识
    let identifier: String
    /// 是否已展开
    var expand: Bool

    /// 初始化
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识
    ///   - expand: 是否展开
    init(identifier: String, expand: Bool) {
        self.identifier = identifier
        self.expand = expand
    }
}
