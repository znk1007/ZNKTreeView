//
//  TreeViewEnum.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/17.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

/// 批量更新类型
///
/// - insertion: 插入
/// - deletion: 删除
/// - update: 更新
enum BatchUpdates {
    case insertion
    case deletion
    case update
}

/// 节点添加模式
///
/// - leading: 插入头部
/// - trailing: 插入尾部
/// - leadingFor: 插入指定节点头部
/// - trailingFor: 插入指定节点尾部
enum TreeNodeInsertMode {
    case leading
    case trailing
    case leadingFor(TreeNode)
    case trailingFor(TreeNode)
}

/// 树形图风格
///
/// - grouped: 分组
/// - plain: 平铺
enum TreeViewStyle {
    case grouped
    case plain
    var style: UITableViewStyle {
        switch self {
        case .grouped:
            return .grouped
        case .plain:
            return .plain
        }
    }
}

/// 单元格分割风格
///
/// - none: 无
/// - singleLine: 单线
enum TreeViewCellSeperatorStyle {
    case none
    case singleLine
    var style: UITableViewCellSeparatorStyle {
        switch self {
        case .none:
            return UITableViewCellSeparatorStyle.none
        case .singleLine:
            return UITableViewCellSeparatorStyle.singleLine
        }
    }

}

/// 表格滚动位置
///
/// - none: 无
/// - top: 顶部
/// - middle: 中间
/// - bottom: 底部
enum TreeViewScrollPosition {
    case none
    case top
    case middle
    case bottom
    var position: UITableViewScrollPosition {
        switch self {
        case .none:
            return UITableViewScrollPosition.none
        case .top:
            return UITableViewScrollPosition.top
        case .middle:
            return UITableViewScrollPosition.middle
        case .bottom:
            return UITableViewScrollPosition.bottom
        }
    }

}

/// 单元格动画效果
///
/// - fade: 渐褪
/// - right: 向右
/// - left: 向左
/// - top: 顶部
/// - bottom: 底部
/// - middle: 中间
/// - automatic: 自动
enum TreeViewRowAnimation {
    case none
    case fade
    case right
    case left
    case top
    case bottom
    case middle
    case automatic
    var animation: UITableViewRowAnimation {
        switch self {
        case .none:
            return UITableViewRowAnimation.none
        case .fade:
            return UITableViewRowAnimation.fade
        case .right:
            return UITableViewRowAnimation.right
        case .left:
            return UITableViewRowAnimation.left
        case .top:
            return UITableViewRowAnimation.top
        case .bottom:
            return UITableViewRowAnimation.bottom
        case .middle:
            return UITableViewRowAnimation.middle
        case .automatic:
            return UITableViewRowAnimation.automatic
        }
    }
}
