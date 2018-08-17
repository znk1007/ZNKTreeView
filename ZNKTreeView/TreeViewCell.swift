//
//  TreeViewCell.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/15.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class TreeViewCell: UITableViewCell {

    struct Setting {
        static let identifier = "TreeViewCellId"
    }

    /// 标签
    private var label: UILabel?
    /// 当前层级
    private var currentLevel: Int = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 子视图
    private func initSubview() {
        label = UILabel.init()
        label?.textColor = .green
        contentView.addSubview(label!)

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let marginLeft = CGFloat.init(currentLevel * 25)
        label?.frame = CGRect.init(x: marginLeft, y: 0, width: contentView.frame.width - marginLeft, height: contentView.frame.height)

    }

    func updateCell(_ text: String, level: Int)  {
        guard let label = label else { return }
        currentLevel = level
        label.text = text
    }

}
