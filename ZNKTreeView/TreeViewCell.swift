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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
