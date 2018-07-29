//
//  TreeViewCell.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/23.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class TreeViewCell: UITableViewCell {

    struct Setting {
        static let identifier = "TreeViewCellId"
    }


    private var nameLabel: UILabel = {
        $0.textAlignment = .left
        $0.textColor = .green
        return $0
    }(UILabel.init())

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
        contentView.addSubview(nameLabel)
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTreeCell(_ item: TreeObject, level: Int) {
        let marginLeft = CGFloat.init(level * 25) + 10
        nameLabel.frame = CGRect.init(x: marginLeft, y: 0, width: frame.width - marginLeft, height: frame.height)
        nameLabel.text = item.name
    }

}
