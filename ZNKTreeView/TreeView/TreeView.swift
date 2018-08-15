//
//  TreeView.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/11.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class TreeView: UIView {

    /// 树形图数据源代理
    var dataSource: TreeViewDataSource?

    /// 预计行高
    var estimatedRowHeight: CGFloat = 0 {
        didSet {
            guard let table = tableView else { return }
            table.estimatedRowHeight = estimatedRowHeight
        }
    }

    /// 预计段尾高度
    var estimatedSectionFooterHeight: CGFloat = 0 {
        didSet {
            guard let table = tableView else { return }
            table.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        }
    }

    /// 预计段头高度
    var estimatedSectionHeaderHeight: CGFloat = 0 {
        didSet {
            guard let table = tableView else { return }
            table.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
        }
    }



    /// 表格视图风格
    private var tableViewStyle: UITableViewStyle
    /// 表格
    private var tableView: UITableView?

    /// 初始化树形图
    ///
    /// - Parameters:
    ///   - frame: 边框
    ///   - style: 风格
    init(frame: CGRect, style: TreeViewStyle) {
        self.tableViewStyle = style.style
        super.init(frame: frame)
        initSubview()
        defaultConfiguration()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// 子视图
    private func initSubview() {
        tableView = UITableView.init(frame: .zero, style: tableViewStyle)
    }

    /// 默认配置
    private func defaultConfiguration() {
        estimatedRowHeight = 0
        estimatedSectionHeaderHeight = 0
        estimatedSectionFooterHeight = 0
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView?.frame = self.bounds
    }
}

// MARK: - 公共方法
extension TreeView {
    /// 刷新数据
    func reloadData() {
        guard let table = tableView else { return }
        table.reloadData()
    }
}
