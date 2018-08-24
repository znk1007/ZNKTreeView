//
//  TreeViewDelegate.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/15.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol TreeViewDelegate {

    /// 指定树形图指定元素高度，默认44
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - item: 指定元素
    /// - Returns: 高度
    func treeView(_ treeView: TreeView, heightFor item: Any?, at indexPath: IndexPath) -> CGFloat

    /// 指定树形图段头高度
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - rootIndex: 根元素下标
    /// - Returns: 高度
    func treeView(_ treeView: TreeView, heightForHeaderIn rootIndex: Int) -> CGFloat

    /// 指定树形图段尾高度
    ///
    /// - Parameters:
    ///   - treeView: 指定树形图
    ///   - rootIndex: 根元素下标
    /// - Returns: 高度
    func treeView(_ treeView: TreeView, heightForFooterIn rootIndex: Int) -> CGFloat

    /// 选择指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, didSelect item: Any, at indexPath: IndexPath)

    /// 将要展开指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, willExpand item: Any, at indexPath: IndexPath)

    /// 已展开指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, didExpand item: Any, at indexPath: IndexPath)

    /// 将要收缩指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, willShrink item: Any, at indexPath: IndexPath)

    /// 已收缩指定元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    func treeView(_ treeView: TreeView, didShrink item: Any, at indexPath: IndexPath)

    /// 将要展示指定的元素
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    func treeView(_ treeView: TreeView, willDisplay item: Any, at indexPath: IndexPath)

    /// 将要展示段头视图
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - view: 段头视图
    ///   - index: 根元素下标
    func treeView(_ treeView: TreeView, willDisplayHeaderView view: UIView, forRoot index: Int)

    /// 将要展示段尾视图
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - view: 段尾视图
    ///   - index: 根元素下标
    func treeView(_ treeView: TreeView, willDisplayFooterView view: UIView, forRoot index: Int)

    /// 完成指定元素单元格展示
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    func treeView(_ treeView: TreeView, didEndDisplaying item: Any, at indexPath: IndexPath)

    /// 完成段头视图展示
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - view: 段头视图
    ///   - index: 地址索引
    func treeView(_ treeView: TreeView, didEndDisplayingHeaderView view: UIView, inRoot index: Int)

    /// 完成段尾视图展示
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - view: 段尾视图
    ///   - index: 地址索引
    func treeView(_ treeView: TreeView, didEndDisplayingFooterView view: UIView, inRoot index: Int)

    /// 指定元素预算高度
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 预算高度
    func treeView(_ treeView: TreeView, estimatedHeightFor item: Any, at indexPath: IndexPath) -> CGFloat

    /// 指定根元素下标段头预算高度
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - index: 根元素下标
    /// - Returns: 预算高度
    func treeView(_ treeView: TreeView, estimatedHeightForHeaderInRoot index: Int) -> CGFloat

    /// 指定根元素下标段尾预算高度
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - index: 根元素下标
    /// - Returns: 预算高度
    func treeView(_ treeView: TreeView, estimatedHeightForFooterInRoot index: Int) -> CGFloat

    /// 点击指示按钮事件
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    func treeView(_ treeView: TreeView, accessoryButtonTappedFor item: Any, at indexPath: IndexPath)

    /// 选中指定元素单元格，是否高亮
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 是否高亮
    func treeView(_ treeView: TreeView, shouldHighlightFor item: Any, at indexPath: IndexPath) -> Bool

    /// 选中单元格已完成高亮
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    func treeView(_ treeView: TreeView, didHighlightFor item: Any, at indexPath: IndexPath)

    /// 已取消指定元素高亮
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    func treeView(_ treeView: TreeView, didUnhighlightFor item: Any, at indexPath: IndexPath)

    /// 将选择指定元素的单元格
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 将选中的地址索引
    func treeView(_ treeView: TreeView, willSelect item: Any, at indexPath: IndexPath) -> IndexPath?

    /// 将取消选择指定元素的单元格
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 将取消选中的地址索引
    func treeView(_ treeView: TreeView, willDeselect item: Any, at indexPath: IndexPath) -> IndexPath?

    /// 指定元素编辑风格
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 编辑风格
    func treeView(_ treeView: TreeView, editingStyleFor item: Any, at indexPath: IndexPath) -> UITableViewCellEditingStyle

    /// 指定元素单元格删除按钮标题
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 标题
    func treeView(_ treeView: TreeView, titleForDeleteConfirmationButtonForItem item: Any, at indexPath: IndexPath) -> String?

    /// 指定元素单元格编辑操作
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 编辑操作
    func treeView(_ treeView: TreeView, editActionsFor item: Any, at indexPath: IndexPath) -> [UITableViewRowAction]?

    /// 指定元素单元格右滑编辑操作配置
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 编辑操作配置
    @available(iOS 11.0, *)
    func treeView(_ treeView: TreeView, leadingSwipeActionsConfigurationFor item: Any, at indexPath: IndexPath) -> UISwipeActionsConfiguration?

    /// 指定元素单元格左滑编辑操作配置
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 编辑操作配置
    @available(iOS 11.0, *)
    func treeView(_ treeView: TreeView, trailingSwipeActionsConfigurationFor item: Any, at indexPath: IndexPath) -> UISwipeActionsConfiguration?

    /// 指定元素单元格是否应该缩进， treeView grouoped时有效
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    /// - Returns: 是否应该缩进
    func treeView(_ treeView: TreeView,  shouldIndentWhileEditingFor item: Any, at indexPath: IndexPath) -> Bool

    /// 将要编辑指定元素单元格
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    func treeView(_ treeView: TreeView, willBeginEditingFor item: Any, at indexPath: IndexPath)

    /// 结束编辑指定元素单元格
    ///
    /// - Parameters:
    ///   - treeView: 树形图
    ///   - item: 指定元素
    ///   - indexPath: 地址索引
    func treeView(_ treeView: TreeView, didEndEditingFor item: Any?, at indexPath: IndexPath?)

}

extension TreeViewDelegate {
    func treeView(_ treeView: TreeView, heightFor item: Any?, at indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func treeView(_ treeView: TreeView, heightForHeaderIn rootIndex: Int) -> CGFloat {
        return 50
    }

    func treeView(_ treeView: TreeView, heightForFooterIn rootIndex: Int) -> CGFloat {
        return 50
    }

    func treeView(_ treeView: TreeView, didSelect item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, willExpand item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, didExpand item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, willShrink item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, didShrink item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, willDisplay item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, willDisplayHeaderView view: UIView, forRoot index: Int) {}

    func treeView(_ treeView: TreeView, willDisplayFooterView view: UIView, forRoot index: Int) {}

    func treeView(_ treeView: TreeView, didEndDisplaying item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, didEndDisplayingHeaderView view: UIView, inRoot index: Int) { }

    func treeView(_ treeView: TreeView, didEndDisplayingFooterView view: UIView, inRoot index: Int) {}

    func treeView(_ treeView: TreeView, estimatedHeightFor item: Any, at indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func treeView(_ treeView: TreeView, estimatedHeightForHeaderInRoot index: Int) -> CGFloat {
        return 50
    }

    func treeView(_ treeView: TreeView, estimatedHeightForFooterInRoot index: Int) -> CGFloat {
        return 50
    }

    func treeView(_ treeView: TreeView, accessoryButtonTappedFor item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, shouldHighlightFor item: Any, at indexPath: IndexPath) -> Bool {
        return true
    }

    func treeView(_ treeView: TreeView, didHighlightFor item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, didUnhighlightFor item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, willSelect item: Any, at indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    func treeView(_ treeView: TreeView, willDeselect item: Any, at indexPath: IndexPath) -> IndexPath? {
        return indexPath
    }

    func treeView(_ treeView: TreeView, editingStyleFor item: Any, at indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }

    func treeView(_ treeView: TreeView, titleForDeleteConfirmationButtonForItem item: Any, at indexPath: IndexPath) -> String? {
        return nil
    }

    func treeView(_ treeView: TreeView, editActionsFor item: Any, at indexPath: IndexPath) -> [UITableViewRowAction]? {
        return nil
    }

    @available(iOS 11.0, *)
    func treeView(_ treeView: TreeView, leadingSwipeActionsConfigurationFor item: Any, at indexPath: IndexPath ) -> UISwipeActionsConfiguration? {
        return nil
    }

    @available(iOS 11.0, *)
    func treeView(_ treeView: TreeView, trailingSwipeActionsConfigurationFor item: Any, at indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }

    func treeView(_ treeView: TreeView,  shouldIndentWhileEditingFor item: Any, at indexPath: IndexPath) -> Bool {
        return false
    }

    func treeView(_ treeView: TreeView, willBeginEditingFor item: Any, at indexPath: IndexPath) {}

    func treeView(_ treeView: TreeView, didEndEditingFor item: Any?, at indexPath: IndexPath?) {}
}


