//
//  TreeViewHeaderView.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/16.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class TreeViewHeaderView: UITableViewHeaderFooterView {

    struct Setting {
        static let identifier = "TreeViewHeaderView"
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
