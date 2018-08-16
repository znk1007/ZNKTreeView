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

    /// 标签
    private var label: UILabel?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        label = UILabel.init()
        label?.textColor = .green
        label?.textAlignment = .center
        self.addSubview(label!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 更新头部数据
    ///
    /// - Parameter text: 文本
    func updateHeader(_ text: String) {
        guard let label = label else { return }
        label.text = text
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = self.bounds
    }
}
