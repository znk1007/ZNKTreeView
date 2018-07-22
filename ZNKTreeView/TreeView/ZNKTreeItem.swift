//
//  ZNKTreeItem.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/22.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class ZNKTreeItem {
    let identifier: String
    var expand: Bool
    init(identifier: String, expand: Bool) {
        self.identifier = identifier
        self.expand = expand
    }
}
