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
        label?.textAlignment = .center
        contentView.addSubview(label!)
        contentView.backgroundColor = .yellow

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        label?.frame = contentView.bounds
    }

    func updateCell(_ text: String)  {
        guard let label = label else { return }
        label.text = text
    }

}
