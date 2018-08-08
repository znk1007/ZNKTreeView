//
//  ZNKTreeViewDelete.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/8/8.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeViewDelete {

    /// 选择item
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didSelect item: ZNKTreeItem?, at indexPath: IndexPath)

    /// 每个ZNKTreeItem行高
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, heightfor item: ZNKTreeItem?) -> CGFloat

    /// 将要展示单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - cell: UITableViewCell
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willDisplay cell: UITableViewCell, for item: ZNKTreeItem?)

    /// 将要展示段头视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段头视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, willDisplayHeaderView view: UIView, for rootIndex: Int)

    /// 将要展示段尾视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段尾视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, willDisplayFooterView view: UIView, for rootIndex: Int)

    /// 完成单元格展示
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - cell: UITableViewCell
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didEndDisplaying cell: UITableViewCell, for item: ZNKTreeItem?)

    /// 完成段尾视图展示
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段尾视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingFooterView view: UIView, for rootIndex: Int)

    /// 完成段头视图展示
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - view: 段头视图
    ///   - rootIndex: 根结点下标
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingHeaderView view: UIView, for rootIndex: Int)

    /// 段头高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, heightForHeaderIn rootIndex: Int) -> CGFloat

    /// 段尾高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, heightForFooterIn rootIndex: Int) -> CGFloat

    /// 单元格预设高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, estimatedHeightFor item: ZNKTreeItem?) -> CGFloat

    /// 段头预设高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForHeaderIn rootIndex: Int) -> CGFloat

    /// 段尾预设高度
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 高度
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForFooterIn rootIndex: Int) -> CGFloat

    /// 段头视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 段头视图
    func treeView(_ treeView: ZNKTreeView, viewForHeaderIn rootIndex: Int) -> UIView?

    /// 段头视图
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - rootIndex: 根结点下标
    /// - Returns: 段头视图
    func treeView(_ treeView: ZNKTreeView, viewForFooterIn rootIndex: Int) -> UIView?

    /// 点击单元格右侧指示按钮事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, accessoryButtonTappedFor item: ZNKTreeItem?)

    /// 是否对ZNKTreeItem高亮
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldHighlightFor item: ZNKTreeItem?) -> Bool

    /// 已对ZNKTreeItem高亮
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, didHighlightFor item: ZNKTreeItem?)

    /// 已对ZNKTreeItem取消高亮
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, didUnhighlightFor item: ZNKTreeItem?)

    /// 将要选择单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willSelect item: ZNKTreeItem?) -> ZNKTreeItem?

    /// 将要取消选择单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willDeselect item: ZNKTreeItem?) -> ZNKTreeItem?

    /// 已取消选择单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didDeselect item: ZNKTreeItem?)

    /// 单元格编辑类型风格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UITableViewCellEditingStyle
    func treeView(_ treeView: ZNKTreeView, editingStyleFor item: ZNKTreeItem?) -> UITableViewCellEditingStyle

    /// 删除按钮标题
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: 标题
    func treeView(_ treeView: ZNKTreeView, titleForDeleteConfirmationButtonFor item: ZNKTreeItem?) -> String?

    /// 单元格事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UITableViewRowAction
    func treeView(_ treeView: ZNKTreeView, editActionsFor item: ZNKTreeItem?) -> [UITableViewRowAction]?

    /// 右滑手势配置
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UISwipeActionsConfiguration
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, leadingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration?

    /// 左滑手势配置
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: UISwipeActionsConfiguration
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, trailingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration?

    /// 单元格编辑过程中是否缩进，默认true
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldIndentWhileEditingFor item: ZNKTreeItem?) -> Bool

    /// 将要编辑单元格
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, willBeginEditingFor item: ZNKTreeItem?)

    /// 已完成单元格编辑
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, didEndEditingFor item: ZNKTreeItem?)

    /// 编辑单元格拖行时所经过的ZNKTreeItem
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - sourceItem: 源ZNKTreeItem
    ///   - item: 目标ZNKTreeItem
    /// - Returns: 所经过的ZNKTreeItem
    func treeView(_ treeView: ZNKTreeView, targetItemForMoveFrom sourceItem: ZNKTreeItem?, toProposed item: ZNKTreeItem?) -> ZNKTreeItem?

    /// 缩进等级
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Int 缩进等级
    func treeView(_ treeView: ZNKTreeView, indentationLevelFor item: ZNKTreeItem?) -> Int

    /// 是否需要显示菜单
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldShowMenuFor item: ZNKTreeItem?) -> Bool

    /// 单元格是否可以响应指定事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - action: Selector
    ///   - item: ZNKTreeItem
    ///   - sender: Any
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canPerformAction action: Selector, for item: ZNKTreeItem?, withSender sender: Any?) -> Bool

    /// 单元格响应指定事件
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - action: Selector
    ///   - item: ZNKTreeItem
    ///   - sender: Any
    func treeView(_ treeView: ZNKTreeView, performAction action: Selector, for item: ZNKTreeItem?, with sender: Any?)

    /// 单元格可以聚焦
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canFocus item: ZNKTreeItem?) -> Bool

    /// 是否需要更新聚焦状态
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - context: UITableViewFocusUpdateContext
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool

    /// 完成聚焦更新
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - context: UITableViewFocusUpdateContext
    ///   - coordinator: UIFocusAnimationCoordinator
    func treeView(_ treeView: ZNKTreeView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator)

    /// 聚焦的ZNKTreeItem
    ///
    /// - Parameter treeView: ZNKTreeView
    /// - Returns: 聚焦的ZNKTreeItem
    func itemForPreferredFocusedView(in treeView: ZNKTreeView) -> ZNKTreeItem?


    /// 弹性加载ZNKTreeItem
    ///
    /// - Parameters:
    ///   - treeView: ZNKTreeView
    ///   - item: ZNKTreeItem
    ///   - context: UISpringLoadedInteractionContext
    /// - Returns: Bool
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, shouldSpringLoad item: ZNKTreeItem?, with context: UISpringLoadedInteractionContext) -> Bool

    /// 是否可以展开元素，默认true
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canExpandItem item: ZNKTreeItem) -> Bool

    /// 将要展开元素
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, willExpandItem item: ZNKTreeItem)

    /// 已完成元素展开
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, didExpandItem item: ZNKTreeItem)

    /// 是否可以收缩元素，默认true
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    /// - Returns: Bool
    func treeView(_ treeView: ZNKTreeView, canFoldItem item: ZNKTreeItem) -> Bool

    /// 将要收缩元素
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, willFoldItem item: ZNKTreeItem)

    /// 已完成元素收缩
    ///
    /// - Parameters:
    ///   - treeView: 树状图
    ///   - item: 元素
    func treeView(_ treeView: ZNKTreeView, didFoldItem item: ZNKTreeItem)
}

extension ZNKTreeViewDelete {
    func treeView(_ treeView: ZNKTreeView, didSelect item: ZNKTreeItem?, at indexPath: IndexPath) {}
    func treeView(_ treeView: ZNKTreeView, heightfor item: ZNKTreeItem?) -> CGFloat { return 0 }
    func treeView(_ treeView: ZNKTreeView, willDisplay cell: UITableViewCell, for item: ZNKTreeItem?)  { }
    func treeView(_ treeView: ZNKTreeView, willDisplayHeaderView view: UIView, for rootIndex: Int) {}
    func treeView(_ treeView: ZNKTreeView, willDisplayFooterView view: UIView, for rootIndex: Int) {}
    func treeView(_ treeView: ZNKTreeView, didEndDisplaying cell: UITableViewCell, for item: ZNKTreeItem?) { }
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingHeaderView view: UIView, for rootIndex: Int) { }
    func treeView(_ treeView: ZNKTreeView, didEndDisplayingFooterView view: UIView, for rootIndex: Int) {}
    func treeView(_ treeView: ZNKTreeView, heightForHeaderIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, heightForFooterIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, estimatedHeightFor item: ZNKTreeItem?) -> CGFloat { return 45 }
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForHeaderIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, estimatedHeightForFooterIn rootIndex: Int) -> CGFloat { return 15 }
    func treeView(_ treeView: ZNKTreeView, viewForHeaderIn rootIndex: Int) -> UIView? { return nil }
    func treeView(_ treeView: ZNKTreeView, viewForFooterIn rootIndex: Int) -> UIView? { return nil }
    func treeView(_ treeView: ZNKTreeView, accessoryButtonTappedFor item: ZNKTreeItem?) { }
    func treeView(_ treeView: ZNKTreeView, shouldHighlightFor item: ZNKTreeItem?) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, didHighlightFor item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, didUnhighlightFor item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, willSelect item: ZNKTreeItem?) -> ZNKTreeItem? { return nil }
    func treeView(_ treeView: ZNKTreeView, willDeselect item: ZNKTreeItem?) -> ZNKTreeItem? { return nil }
    func treeView(_ treeView: ZNKTreeView, didDeselect item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, editingStyleFor item: ZNKTreeItem?) -> UITableViewCellEditingStyle { return .none }
    func treeView(_ treeView: ZNKTreeView, titleForDeleteConfirmationButtonFor item: ZNKTreeItem?) -> String? { return nil }
    func treeView(_ treeView: ZNKTreeView, editActionsFor item: ZNKTreeItem?) -> [UITableViewRowAction]? { return nil }
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, leadingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration? { return nil }
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, trailingSwipeActionsConfigurationFor item: ZNKTreeItem?) -> UISwipeActionsConfiguration? { return nil }
    func treeView(_ treeView: ZNKTreeView, shouldIndentWhileEditingFor item: ZNKTreeItem?) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, willBeginEditingFor item: ZNKTreeItem?) { }
    func treeView(_ treeView: ZNKTreeView, didEndEditingFor item: ZNKTreeItem?) {}
    func treeView(_ treeView: ZNKTreeView, targetItemForMoveFrom sourceItem: ZNKTreeItem?, toProposed item: ZNKTreeItem?) -> ZNKTreeItem? { return nil }
    func treeView(_ treeView: ZNKTreeView, indentationLevelFor item: ZNKTreeItem?) -> Int { return 0 }
    func treeView(_ treeView: ZNKTreeView, shouldShowMenuFor item: ZNKTreeItem?) -> Bool { return false }
    func treeView(_ treeView: ZNKTreeView, canPerformAction action: Selector, for item: ZNKTreeItem?, withSender sender: Any?) -> Bool { return false }
    func treeView(_ treeView: ZNKTreeView, performAction action: Selector, for item: ZNKTreeItem?, with sender: Any?) { }
    func treeView(_ treeView: ZNKTreeView, canFocus item: ZNKTreeItem?) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) { }
    func itemForPreferredFocusedView(in treeView: ZNKTreeView) -> ZNKTreeItem? { return nil }
    @available(iOS 11.0, *)
    func treeView(_ treeView: ZNKTreeView, shouldSpringLoad item: ZNKTreeItem?, with context: UISpringLoadedInteractionContext) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, canExpandItem item: ZNKTreeItem) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, willExpandItem item: ZNKTreeItem) { }
    func treeView(_ treeView: ZNKTreeView, didExpandItem item: ZNKTreeItem) { }
    func treeView(_ treeView: ZNKTreeView, canFoldItem item: ZNKTreeItem) -> Bool { return true }
    func treeView(_ treeView: ZNKTreeView, willFoldItem item: ZNKTreeItem) { }
    func treeView(_ treeView: ZNKTreeView, didFoldItem item: ZNKTreeItem) { }
}
