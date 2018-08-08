//
//  ZNKTreeViewEnums.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/8.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

/// 元素插入模式
///
/// - leading: 头部
/// - trailing: 尾部
/// - leadingFor: 指定元素头部
/// - trailingFor: 地址元素尾部
enum ZNKTreeItemInsertMode {
    case leading
    case trailing
    case leadingFor(ZNKTreeItem)
    case trailingFor(ZNKTreeItem)
}

//MARK: ************************** ZNKTreeItem ***********************


/// 批量更新类型
enum BatchUpdates {
    /// 插入
    case insertion
    /// 删除
    case deletion
    /// 移动
    case move
}


/// 树形图展示类型
///
/// - grouped: 分组
/// - plain: 平铺
enum ZNKTreeViewStyle {
    case grouped
    case plain
    var tableStyle: UITableViewStyle {
        switch self {
        case .grouped:
            return UITableViewStyle.grouped
        case .plain:
            return UITableViewStyle.plain
        }
    }

}

/// 单元格分割风格
///
/// - none: 无
/// - singleLine: 单线
/// - singleLineEtched: 单线蚀刻
enum ZNKTreeViewCellSeperatorStyle {
    case none
    case singleLine
    case singleLineEtched
    var style: UITableViewCellSeparatorStyle {
        switch self {
        case .none:
            return UITableViewCellSeparatorStyle.none
        case .singleLine:
            return UITableViewCellSeparatorStyle.singleLine
        case .singleLineEtched:
            return UITableViewCellSeparatorStyle.singleLineEtched
        }
    }

}

/// 表格滚动位置
///
/// - none: 无
/// - top: 顶部
/// - middle: 中间
/// - bottom: 底部
enum ZNKTreeViewScrollPosition {
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
enum ZNKTreeViewRowAnimation {
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
