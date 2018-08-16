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

    /// 时间回调
    private var hearderBtnAction: ((Bool) -> ())?
    /// 按钮
    private var button: UIButton?

    /// 标签
    private var label: UILabel?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 子视图
    private func initSubview() {
        label = UILabel.init()
        label?.textColor = .green
        label?.textAlignment = .center
        contentView.addSubview(label!)
        contentView.backgroundColor = .yellow

        button = UIButton.init(type: .custom)
        button?.addTarget(self, action: #selector(headerAction(_:)), for: .touchUpInside)
        contentView.addSubview(button!)
    }

    @objc func headerAction(_ btn: UIButton) {
        btn.isSelected = !btn.isSelected
        hearderBtnAction?(btn.isSelected)
    }
    /// 更新头部数据
    ///
    /// - Parameter text: 文本
    func updateHeader(_ text: String, completion: ((Bool) -> ())?) {
        guard let label = label else { return }
        label.text = text
        hearderBtnAction = completion
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = self.contentView.bounds
        button?.frame = self.contentView.bounds
    }
}
