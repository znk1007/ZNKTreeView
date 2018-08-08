//
//  ZNKTreeView.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//


import UIKit

final class ZNKTreeView: UIView {

    //MARK: ******Public*********

    /// 代理
    var delegate: ZNKTreeViewDelete?
    /// 数据源
    var dataSource: ZNKTreeViewDataSource?
    /// 预取数据源
    //    var prefetchDataSource: ZNKTreeViewDataSourcePrefetching?
    /// 预估行高 默认0
    var estimatedRowHeight: CGFloat = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.estimatedRowHeight = estimatedRowHeight
        }
    }

    /// 是否同步
    var async: Bool = false

    /// 预估段尾高度 默认0
    var estimatedSectionFooterHeight: CGFloat = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.estimatedSectionFooterHeight = estimatedSectionFooterHeight
        }
    }
    /// 预估段头高度 默认0
    var estimatedSectionHeaderHeight: CGFloat = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.estimatedSectionHeaderHeight = estimatedSectionHeaderHeight
        }
    }

    /// 背景视图
    var backgroundView: UIView? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.backgroundView = backgroundView
        }
    }

    /// 分割线嵌入
    var separatorInset: UIEdgeInsets = .zero {
        didSet {
            guard let table = treeTable else { return }
            table.separatorInset = separatorInset
        }
    }


    /// 树形图行高
    var treeViewRowHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            guard let table = treeTable else { return }
            table.rowHeight = treeViewRowHeight
        }
    }

    /// 分割风格
    var separatorStyle: ZNKTreeViewCellSeperatorStyle = .none {
        didSet {
            guard let table = treeTable else { return }
            table.separatorStyle = separatorStyle.style
        }
    }

    /// 分割颜色
    var separatorColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.separatorColor = separatorColor
        }
    }

    /// 调整右侧像素
    var cellLayoutMarginsFollowReadableWidth: Bool = false {
        didSet {
            guard let table = treeTable else { return }
            table.cellLayoutMarginsFollowReadableWidth = cellLayoutMarginsFollowReadableWidth
        }
    }

    /// 分割效果
    var seperatorEffect: UIVisualEffect? {
        didSet {
            guard let table = treeTable else { return }
            table.separatorEffect = seperatorEffect
        }
    }
    // 段头高度 默认 UITableViewAutomaticDimension
    var sectionHeaderHeight: CGFloat = UITableViewAutomaticDimension {
        didSet {
            guard let table = treeTable else { return }
            table.sectionHeaderHeight = sectionHeaderHeight
        }
    }
    // 段尾高度 默认 UITableViewAutomaticDimension
    var sectionFooterHeight: CGFloat = UITableViewAutomaticDimension{
        didSet {
            guard let table = treeTable else { return }
            table.sectionFooterHeight = sectionFooterHeight
        }
    }

    /// 元素是否在编辑状态
    var isItemEditing: Bool {
        set {
            guard let table = treeTable else { return }
            table.isEditing = newValue
        }
        get {
            guard let table = treeTable else { return false }
            return table.isEditing
        }
    }

    /// 非编辑状态下是否可选
    var allowsItemSelection: Bool {
        set {
            guard let table = treeTable else { return }
            table.allowsSelection = allowsItemSelection
        }
        get {
            guard let table = treeTable else { return false }
            return table.allowsSelection
        }
    }

    /// 编辑状态下是否可选
    var allowsItemSelectionDuringEditing: Bool {
        set {
            guard let table = treeTable else { return }
            table.allowsSelectionDuringEditing = allowsItemSelectionDuringEditing
        }
        get {
            guard let table = treeTable else { return false }
            return table.allowsSelectionDuringEditing
        }
    }


    /// 是否允许多选
    var allowsMultipleItemSelection: Bool {
        set {
            guard let table = treeTable else { return }
            table.allowsMultipleSelection = allowsMultipleItemSelection
        }
        get {
            guard let table = treeTable else { return false }
            return table.allowsMultipleSelection
        }
    }

    /// 编辑状态下是否可以多选
    var allowsMultipleItemSelectionDuringEditing: Bool {
        get {
            guard let table = treeTable else { return false }
            return table.allowsMultipleSelectionDuringEditing
        }
        set {
            guard let table = treeTable else { return }
            table.allowsMultipleSelectionDuringEditing = allowsMultipleItemSelectionDuringEditing
        }
    }

    /// 选中元素的地址索引
    var indexPathForSelectedItem: IndexPath? {
        guard let table = treeTable else { return nil }
        return table.indexPathForSelectedRow
    }
    /// 选中元素的地址索引数组
    var indexPathsForSelectedItems: [IndexPath]? {
        guard let table = treeTable else { return nil }
        return table.indexPathsForVisibleRows

    }

    /// 每段最少显示元素数
    var sectionIndexMinimumDisplayItemCount: Int = 0 {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexMinimumDisplayRowCount = sectionIndexMinimumDisplayItemCount
        }
    }

    /// 段下标颜色
    var sectionIndexColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexColor = sectionIndexColor
        }
    }

    /// 段下标背景颜色
    var sectionIndexBackgroundColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexBackgroundColor = sectionIndexBackgroundColor
        }
    }

    /// /// 段下标轨迹背景颜色
    var sectionIndexTrackingBackgroundColor: UIColor? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.sectionIndexTrackingBackgroundColor = sectionIndexTrackingBackgroundColor
        }
    }

    /// 内容视图嵌入安全域
    var insetsContentViewsToSafeArea: Bool = true {
        didSet {
            guard let table = treeTable else { return }
            if #available(iOS 11.0, *) {
                table.insetsContentViewsToSafeArea = insetsContentViewsToSafeArea
            } else {
                // Fallback on earlier versions
            }
        }
    }

    /// 树形图头部视图
    var treeHeaderView: UIView? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.tableHeaderView = treeHeaderView
        }
    }

    /// 树形图尾部视图
    var treeFooterView: UIView? = nil {
        didSet {
            guard let table = treeTable else { return }
            table.tableFooterView = treeFooterView
        }
    }

    /// 记住最后选中的元素
    var remembersLastFocusedItem: Bool = false {
        didSet {
            guard let table = treeTable else { return }
            table.remembersLastFocusedIndexPath = remembersLastFocusedItem
        }
    }

    /// 是否允许拖拽
    var dragInteractionEnabled: Bool = false {
        didSet {
            guard let table = treeTable else { return }
            if #available(iOS 11.0, *) {
                table.dragInteractionEnabled = dragInteractionEnabled
            } else {
                // Fallback on earlier versions
            }
        }
    }

    /// 是否激活拖拽
    var hasActiveDrag: Bool {
        get {
            guard let table = treeTable else { return false }
            if #available(iOS 11.0, *) {
                return table.hasActiveDrag
            } else {
                // Fallback on earlier versions
                return false
            }
        }
    }

    /// 根元素数
    var numberOfRootItems: Int {
        guard let table = treeTable else { return 0 }
        return table.numberOfSections
    }

    /// 展开元素时，是否同时展开所有子元素，默认false
    var expandChildrenWhenItemExpand: Bool = false

    /// 展开元素动画模式 默认none
    var expandAnimation: ZNKTreeViewRowAnimation = .none

    /// 收缩元素时，是否同时收缩所有子元素，默认false
    var foldChildrenWhenItemFold: Bool = false

    /// 收缩动画模式，默认none
    var foldAnimation: ZNKTreeViewRowAnimation = .none

    //MARK: ******Private*********
    /// 表格
    private var treeTable: UITableView!

    /// 显示类型
    private var style: ZNKTreeViewStyle = .plain

    /// 收缩展开点击的节点
    private var specilaNode: ZNKTreeNode? = nil
    /// 节点管理
    private var manager: ZNKTreeNodeController?

    /// 插入数据互斥锁
    private var insertMutex: pthread_mutex_t = .init()
    /// 初始化
    ///
    /// - Parameters:
    ///   - frame: 坐标及大小
    ///   - style: 类型
    init(frame: CGRect, style: ZNKTreeViewStyle) {
        super.init(frame: frame)
        self.insertMutex = pthread_mutex_t.init()
        self.style = style
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.style = .plain
        self.commonInit()
    }

    deinit {
        treeTable.delegate = nil
        treeTable.dataSource = nil
        treeTable = nil
        manager = nil
        pthread_mutex_destroy(&insertMutex)
    }

    /// 初始化
    private func commonInit() {
        if treeTable == nil {
            initTable()
        }
        initConfiguration()
    }


    /// 初始化视图
    private func initTable() {
        self.treeTable = UITableView.init(frame: bounds, style: style.tableStyle)
        treeTable.autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
        treeTable.estimatedRowHeight = 0
        treeTable.estimatedSectionHeaderHeight = 0
        treeTable.estimatedSectionFooterHeight = 0
        treeTable.dataSource = self
        treeTable.delegate = self
        self.addSubview(treeTable)
        allowsItemSelection = true
        allowsMultipleItemSelection = false
        allowsItemSelectionDuringEditing = false
    }

    /// 初始化配置
    private func initConfiguration() {
        manager = .init()
        manager?.delegate = self
    }
}


//MARK: ************ public methods ******************
extension ZNKTreeView {

    /// 指定元素层级
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - indexRootPath: 根结点地址索引
    /// - Returns: 层级
    func levelFor(_ item: ZNKTreeItem, at indexRootPath: IndexPath? = nil) -> Int {
        return manager?.levelfor(item, at: indexRootPath) ?? -1
    }

    /// 指定元素地址索引
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - indexPath: 根结点地址索引
    /// - Returns: 地址索引
    func indexPathFor(_ item: ZNKTreeItem, at indexPath: IndexPath? = nil ) -> IndexPath? {
        return manager?.treeNodeForItem(item, at: indexPath?.section)?.indexPath
    }

    /// 注册UITableViewCell类
    ///
    /// - Parameters:
    ///   - cellClass: UITableViewCell类
    ///   - identifier: 唯一标识
    func register(_ cellClass: AnyClass?, forCellReuseIdentifier identifier: String)  {
        guard let table = treeTable else { return }
        table.register(cellClass, forCellReuseIdentifier: identifier)
    }

    /// 注册UITableViewCell的UINib
    ///
    /// - Parameters:
    ///   - nib: UINib
    ///   - identifier: 唯一标识
    func register(_ nib: UINib?, forCellReuseIdentifier identifier: String) {
        guard let table = treeTable else { return }
        table.register(nib, forCellReuseIdentifier: identifier)

    }

    /// 注册UITableView头部类
    ///
    /// - Parameters:
    ///   - aClass: 头部视图类
    ///   - identifier: 唯一标识
    func register(_ aClass: AnyClass?, forHeaderFooterViewReuseIdentifier identifier: String) {
        guard let table = treeTable else { return }
        table.register(aClass, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// 注册UITableView头部UINib
    ///
    /// - Parameters:
    ///   - nib: UINib
    ///   - identifier: 唯一标识
    func register(_ nib: UINib?, forHeaderFooterViewReuseIdentifier identifier: String) {
        guard let table = treeTable else { return }
        table.register(nib, forHeaderFooterViewReuseIdentifier: identifier)
    }

    /// 复用UITableViewCell
    ///
    /// - Parameter identifier: 唯一标识
    /// - Returns: UITableViewCell 可能为nil
    func dequeueReusableCell(_ identifier: String) -> UITableViewCell? {
        guard let table = treeTable else { return nil }
        return table.dequeueReusableCell(withIdentifier: identifier)
    }

    /// 复用UITableViewCell
    ///
    /// - Parameters:
    ///   - identifier: 唯一标识
    ///   - indexPath: 地址索引
    /// - Returns: UITableViewCell
    func dequeueReusableCell(_ identifier: String, for indexPath: IndexPath) -> UITableViewCell {
        guard let table = treeTable else { return .init() }
        return table.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }

    /// 复用段头段尾
    ///
    /// - Parameter identifier: 唯一标识
    /// - Returns: UITableViewHeaderFooterView?
    func dequeueReusableHeaderFooterView(_ identifier: String) -> UITableViewHeaderFooterView? {
        guard let table = treeTable else { return nil }
        return table.dequeueReusableHeaderFooterView(withIdentifier: identifier)
    }

    /// 刷新表格
    func reloadData() {
        guard let table = treeTable, let manager = manager else { return }
        manager.rootTreeNodes()
        if #available(iOS 11, *) {
            if !table.hasUncommittedUpdates {
                table.reloadData()
            }
        } else {
            table.reloadData()
        }
    }

    /// 根元素下所有显示的子元素数量
    ///
    /// - Parameter rootIndex: 根下标
    /// - Returns: 子元素数量
    func numberOfChildren(inRoot index: Int) -> Int {
        guard let table = treeTable else { return 0 }
        return table.numberOfRows(inSection: index)
    }

    /// 包括头部，尾部，所有行的边框
    ///
    /// - Parameter index: 根下标
    /// - Returns: CGRect
    func treeRect(forRoot index: Int) -> CGRect {
        guard let table = treeTable else { return .zero }
        return table.rect(forSection: index)
    }

    /// 头部边框
    ///
    /// - Parameter index: 根下标
    /// - Returns: CGRect
    func treeRectForHeader(inRoot index: Int) -> CGRect {
        guard let table = treeTable else { return .zero }
        return table.rectForHeader(inSection: index)
    }

    /// 尾部边框
    ///
    /// - Parameter index: 根下标
    /// - Returns: CGRect
    func treeRectForFooter(inRoot index: Int) -> CGRect {
        guard let table = treeTable else { return .zero }
        return table.rectForFooter(inSection: index)
    }

    /// 指定元素边框
    ///
    /// - Parameter item: 指定元素
    /// - Returns: CGRect
    func treeRectForItem(_ item: ZNKTreeItem, at indexPath: IndexPath) -> CGRect {
        guard let table = treeTable, let indexPath = manager?.treeNodeForItem(item, at: indexPath.section)?.indexPath else { return .zero }
        return table.rectForRow(at: indexPath)
    }

    /// 指定坐标的元素, 超出表格，则为nil
    ///
    /// - Parameter point: 坐标
    /// - Returns: 元素
    func treeItem(at point: CGPoint) -> ZNKTreeItem? {
        guard let table = treeTable, let indexPath = table.indexPathForRow(at: point) else { return nil }
        return manager?.treeNodeForIndexPath(indexPath)?.item
    }

    /// 指定单元格的元素
    ///
    /// - Parameter cell: 单元格
    /// - Returns: 元素
    func treeItem(for cell: UITableViewCell) -> ZNKTreeItem? {
        guard let table = treeTable, let indexPath = table.indexPath(for: cell) else { return nil }
        return manager?.treeNodeForIndexPath(indexPath)?.item
    }

    /// 指定边框的所有元素
    ///
    /// - Parameter rect: 边框
    /// - Returns: 元素数组
    func treeItems(in rect: CGRect) -> [ZNKTreeItem]? {
        guard let table = treeTable, let indexPaths = table.indexPathsForRows(in: rect) else { return nil }
        var items: [ZNKTreeItem] = []
        for indexPath in indexPaths {
            if let item = manager?.treeNodeForIndexPath(indexPath)?.item {
                objc_sync_enter(self)
                items.append(item)
                objc_sync_exit(self)
            }
        }
        return items
    }

    /// 指定元素的单元格
    ///
    /// - Parameter item: 指定元素
    /// - Returns: 单元格
    func cell(for item: ZNKTreeItem, at indexPath: IndexPath?) -> UITableViewCell? {
        guard let table = treeTable, let indexPath = manager?.treeNodeForItem(item, at: indexPath?.section)?.indexPath else { return nil }
        return table.cellForRow(at: indexPath)
    }

    /// 可见的元素数组
    var visibleItems: [ZNKTreeItem] {
        guard let table = treeTable else { return [] }
        var items: [ZNKTreeItem] = []
        for cell in table.visibleCells {
            if let item = treeItem(for: cell) {
                objc_sync_enter(self)
                items.append(item)
                objc_sync_exit(self)
            }
        }
        return items
    }

    /// 段头视图
    ///
    /// - Parameter index: 根元素下标
    /// - Returns: 段头视图
    func treeHeaderView(forRoot index: Int) -> UITableViewHeaderFooterView? {
        guard let table = treeTable else { return nil }
        return table.headerView(forSection: index)
    }

    /// 段尾视图
    ///
    /// - Parameter index: 根元素下标
    /// - Returns: 段尾视图
    func treeFooterView(forRoot index: Int) -> UITableViewHeaderFooterView? {
        guard let table = treeTable else { return nil }
        return table.footerView(forSection: index)
    }

    /// 滚动到指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - position: 滚动位置
    ///   - animated: 动画
    func scrollToItem(_ item: ZNKTreeItem, at indexPath: IndexPath? = nil, at position: ZNKTreeViewScrollPosition, animated: Bool) {
        guard let table = treeTable, let indexPath = manager?.treeNodeForItem(item, at: indexPath?.section)?.indexPath else { return }
        table.scrollToRow(at: indexPath, at: position.position, animated: animated)
    }

    /// 滚动至选择item附件
    ///
    /// - Parameters:
    ///   - position: 滚动位置
    ///   - animated: 动画
    func scrollToNearestSelectedItem(at position: ZNKTreeViewScrollPosition, animated: Bool) {
        guard let table = treeTable else { return }
        table.scrollToNearestSelectedRow(at: position.position, animated: animated)
    }

    /// 插入元素数组
    ///
    /// - Parameters:
    ///   - items: 元素数组
    ///   - parent: 父元素
    ///   - indexPath: 地址索引
    ///   - mode: 模式
    ///   - animation: 动画
    func insertItems(_ items: [ZNKTreeItem], in parent: ZNKTreeItem?, at rootIndex: Int, mode: ZNKTreeItemInsertMode = .leading, animation: ZNKTreeViewRowAnimation = .none) {
        guard self.treeTable != nil else { return }
        for item in items {
            insertItem(item, in: parent, at: rootIndex, mode: mode, animation: animation)
        }
    }

    /// 插入元素
    ///
    /// - Parameters:
    ///   - item: 元素
    ///   - parent: 父元素
    ///   - indexPath: 地址索引
    ///   - mode: 模式
    ///   - animation: 动画
    func insertItem(_ item: ZNKTreeItem, in parent: ZNKTreeItem?, at rootIndex: Int, mode: ZNKTreeItemInsertMode = .leading, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = self.treeTable else { return }
        if async {
            manager?.insertItem(item, in: parent, at: rootIndex, mode: mode, completion: { [weak self](indexPaths) in
                if let indexPaths = indexPaths {
                    if #available(iOS 11, *) {
                        self?.treeTable.performBatchUpdates({
                            self?.treeTable.insertRows(at: indexPaths, with: animation.animation)
                        }, completion: nil)
                    } else {
                        self?.treeTable.beginUpdates()
                        self?.treeTable.insertRows(at: indexPaths, with: animation.animation)
                        self?.treeTable.endUpdates()
                    }
                }
            })
        } else {
            guard let childIndexPaths = manager?.insertItem(item, in: parent, at: rootIndex, mode: mode) else { return }
            if #available(iOS 11, *) {
                table.performBatchUpdates({
                    self.treeTable.insertRows(at: childIndexPaths, with: animation.animation)
                }, completion: nil)
            } else {
                table.beginUpdates()
                self.treeTable.insertRows(at: childIndexPaths, with: animation.animation)
                table.endUpdates()
            }
        }
    }


    /// 删除指定元素数组
    ///
    /// - Parameters:
    ///   - items: 指定元素数组
    ///   - parent: 父元素
    ///   - animation: 动画
    func deleteItems(_ items: [ZNKTreeItem], at rootIndex: Int, animation: ZNKTreeViewRowAnimation = .none)  {
        guard self.treeTable != nil else { return }
        for item in items {
            deleteItem(item, at: rootIndex, animation: animation)
        }
    }

    /// 删除指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - parent: 父元素
    ///   - animation: 动画
    func deleteItem(_ item: ZNKTreeItem, at rootIndex: Int, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = self.treeTable else { return }
        if async {
            manager?.deleteItem(item, at: rootIndex, completion: { (indexPaths) in
                if let indexPaths = indexPaths {
                    if #available(iOS 11, *) {
                        table.performBatchUpdates({
                            self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                        }, completion: nil)
                    } else {
                        table.beginUpdates()
                        self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                        table.endUpdates()
                    }
                }
            })
        } else {
            guard let indexPaths = manager?.deleteItem(item, at: rootIndex) else { return }
            if #available(iOS 11, *) {
                table.performBatchUpdates({
                    self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                }, completion: nil)
            } else {
                table.beginUpdates()
                self.treeTable.deleteRows(at: indexPaths, with: animation.animation)
                table.endUpdates()
            }
        }
    }

    /// 更新指定元素
    ///
    /// - Parameters:
    ///   - item: 指定
    ///   - rootIndex: 跟节点地址
    ///   - animation: 动画
    func reloadItem(_ item: ZNKTreeItem, at rootIndex: Int, animation: ZNKTreeViewRowAnimation = .none)  {
        guard let table = self.treeTable else { return }
        if async {
            manager?.reloadItem(item, at: rootIndex, completion: { (indexPath) in
                if let indexPath = indexPath {
                    if #available(iOS 11, *) {
                        table.performBatchUpdates({
                            table.reloadRows(at: [indexPath], with: animation.animation)
                        }, completion: nil)
                    } else {
                        table.beginUpdates()
                        table.reloadRows(at: [indexPath], with: animation.animation)
                        table.endUpdates()
                    }
                }
            })
        } else {
            guard let indexPath = manager?.reloadItem(item, at: rootIndex) else { return }
            if #available(iOS 11, *) {
                table.performBatchUpdates({
                    table.reloadRows(at: [indexPath], with: animation.animation)
                }, completion: nil)
            } else {
                table.beginUpdates()
                table.reloadRows(at: [indexPath], with: animation.animation)
                table.endUpdates()
            }
        }
    }

    /// 展开指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - expandChildren: 是否展开指定元素的子元素
    ///   - rootIndex: 根结点数
    ///   - animation: 动画
    func expandItem(_ item: ZNKTreeItem, expandChildren: Bool, at rootIndex: Int, animation: ZNKTreeViewRowAnimation) {
        guard let table = treeTable else { return }
        if item.expand == true {
            return
        }
        expandChildrenWhenItemExpand = expandChildren
//        expandItemForTreeNode(<#T##treeNode: ZNKTreeNode##ZNKTreeNode#>, allowsDelegate: <#T##Bool#>, at: <#T##IndexPath#>)
    }



    /// 收缩指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - foldChildren: 是否收缩子元素
    ///   - indexPath: 根结点下标
    ///   - animation: 动画
    func foldItem(_ item: ZNKTreeItem, foldChildren: Bool, at indexPath: IndexPath, animation: ZNKTreeViewRowAnimation) {
        guard let table = treeTable else { return }
        if item.expand == false {
            return
        }
        if async {

        } else {

        }
    }

    /// 选择指定元素,不会触发didSelect或didDeselect代理方法或者对应通知
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - rootIndex: 根节点下标
    ///   - animated: 动画
    ///   - position: 位置
    func selectItem(_ item: ZNKTreeItem, at indexPath: IndexPath, animated: Bool, position: ZNKTreeViewScrollPosition) {
        guard let table = treeTable, let node = manager?.treeNodeForItem(item, at: indexPath.section), node.expanded == true else { return }
        table.selectRow(at: node.indexPath, animated: animated, scrollPosition: position.position)
    }

    /// 取消选择指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - rootIndex: 根节点下标
    ///   - animated: 动画
    func deselectItem(_ item: ZNKTreeItem, at rootIndex: Int?, animated: Bool) {
        guard let table = treeTable, let node = manager?.treeNodeForItem(item, at: rootIndex), node.expanded == true else { return }
        table.deselectRow(at: node.indexPath, animated: animated)
    }

    /// 移动指定元素
    ///
    /// - Parameters:
    ///   - item: 指定元素
    ///   - sourceRootIndex: 源根结点下标
    ///   - targetItem: 目标元素
    ///   - targetRootIndex: 目标根结点下标
    ///   - mode: 插入模式
    func moveItem(_ item: ZNKTreeItem, at sourceindexPath: IndexPath, to targetItem: ZNKTreeItem, at targetIndexPath: IndexPath, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = treeTable, let sourceNode = manager?.treeNodeForItem(item, at: targetIndexPath.section), let targetNode = manager?.treeNodeForItem(targetItem, at: targetIndexPath.section) else { return }
        if (sourceNode.parent != nil && sourceNode.parent?.expanded == false) || (targetNode.parent != nil && targetNode.parent?.expanded == false) {
            return
        }
        table.moveRow(at: sourceNode.indexPath, to: targetNode.indexPath)
        deleteItem(item, at: sourceNode.indexPath.section, animation: animation)
        insertItem(item, in: targetNode.parent?.item, at: targetIndexPath.section, mode: ZNKTreeItemInsertMode.leadingFor(targetItem), animation: animation)
    }


    /// 移动单元格
    ///
    /// - Parameters:
    ///   - sourceIndexPath: 源地址索引
    ///   - targetIndexPath: 目标地址索引
    ///   - animation: 动画
    func moveItem(_ sourceIndexPath: IndexPath, to targetIndexPath: IndexPath, animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = treeTable, let sourceNode = manager?.treeNodeForIndexPath(sourceIndexPath), let targetNode = manager?.treeNodeForIndexPath(targetIndexPath)  else { return }
        if (sourceNode.parent != nil && sourceNode.parent?.expanded == false) || (targetNode.parent != nil && targetNode.parent?.expanded == false) {
            return
        }
        table.moveRow(at: sourceIndexPath, to: targetIndexPath)
        deleteItem(sourceNode.item, at: sourceNode.indexPath.section, animation: animation)
        insertItem(sourceNode.item, in: targetNode.parent?.item, at: targetNode.indexPath.section, mode: ZNKTreeItemInsertMode.leadingFor(targetNode.item), animation: animation)
    }

    /// 设置树状图编辑状态，具备动画
    ///
    /// - Parameters:
    ///   - editing: 编辑状态
    ///   - animated: 动画
    func setItemEiditing(_ editing: Bool, animated: Bool) {
        guard let table = treeTable else { return }
        table.setEditing(editing, animated: animated)
    }

}

//MARK: ******************** Private Methods ************************
extension ZNKTreeView {

    /// 展开元素
    ///
    /// - Parameters:
    ///   - treeNode: 元素节点
    ///   - allowDelegate: 允许代理
    fileprivate func expandItemForTreeNode(_ treeNode: ZNKTreeNode, allowsDelegate: Bool = true) {
        guard let table = treeTable, treeNode.children.count > 0 else {
            return
        }
        if allowsDelegate {
            if let delegate = delegate {
                delegate.treeView(self, willExpandItem: treeNode.item)
            }
        }
        func expandTreeNode() {
            if treeNode.expanded == true {
                return
            }
            treeNode.expanded = true
            if expandChildrenWhenItemExpand {
                treeNode.updateChildrenExpand(true)
            }
            table.reloadData()
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            if let weakSelf = self {
                if let delegate = weakSelf.delegate, allowsDelegate {
                    DispatchQueue.main.async {
                        delegate.treeView(weakSelf, didExpandItem: treeNode.item)
                        table.selectRow(at: treeNode.indexPath, animated: false, scrollPosition: .none)
                    }
                }
            }
        }
        expandTreeNode()
        CATransaction.commit()
    }


    /// 折叠指定节点的子节点单元格
    ///
    /// - Parameters:
    ///   - treeNode: 指定节点
    ///   - allowsDelegate: 允许代理
    fileprivate func foldItemForTreeNode(_ treeNode: ZNKTreeNode, allowsDelegate: Bool = true) {
        guard let table = treeTable, treeNode.children.count > 0 else {
            return
        }
        if allowsDelegate {
            if let delegate = delegate {
                delegate.treeView(self, willFoldItem: treeNode.item)
            }
        }
        func foldTreeNode() {
            if treeNode.expanded == false {
                return
            }
            treeNode.expanded = false
            if foldChildrenWhenItemFold {
                treeNode.updateChildrenExpand(false)
            }
            table.reloadData()
        }
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            if let weakSelf = self {
                if let delegate = weakSelf.delegate {
                    DispatchQueue.main.async {
                        delegate.treeView(weakSelf, didFoldItem: treeNode.item)
                        table.selectRow(at: treeNode.indexPath, animated: false, scrollPosition: .none)
                    }
                }
            }
        }
        foldTreeNode()
        CATransaction.commit()
    }

    /// 批量更新表格
    ///
    /// - Parameters:
    ///   - type: 更新类型
    ///   - indexPaths: 地址索引数组
    ///   - animation: 动画
    fileprivate func batchUpdates(_ type: BatchUpdates, indexPaths: [IndexPath], animation: ZNKTreeViewRowAnimation = .none) {
        guard let table = treeTable, indexPaths.count > 0 else { return }
        if #available(iOS 11, *) {
            table.performBatchUpdates({
                switch type {
                case .insertion:
                    table.insertRows(at: indexPaths, with: animation.animation)
                case .deletion:
                    table.deleteRows(at: indexPaths, with: animation.animation)
                default:
                    break
                }
            }, completion: nil)
        } else {
            table.beginUpdates()
            switch type {
            case .insertion:
                table.insertRows(at: indexPaths, with: animation.animation)
            case .deletion:
                table.deleteRows(at: indexPaths, with: animation.animation)
            default:
                break
            }
            table.endUpdates()
        }
    }
}

//extension ZNKTreeView: UITableViewDataSourcePrefetching {
//
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        if let prefetch = prefetchDataSource {
//            var items: [ZNKTreeItem] = []
//            for indexPath in indexPaths {
//                if let item = manager?.treeNodeForItem(indexPath) {
//                    objc_sync_enter(self)
//                    items.append(item)
//                    objc_sync_exit(self)
//                }
//            }
//
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
//
//    }
//}

//MARK: *************** UITableViewDelegate ****************

extension ZNKTreeView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let manager = manager, let treeNode = manager.treeNodeForIndexPath(indexPath) else { return }
        if let delegate = delegate {
            delegate.treeView(self, didSelect: treeNode.item, at: indexPath)
        }
        guard treeNode.children.count > 0 else {
            return
        }
        if treeNode.expanded {
            if let delegate = delegate {
                if delegate.treeView(self, canFoldItem: treeNode.item) {
                    foldItemForTreeNode(treeNode)
                }
            } else {
                foldItemForTreeNode(treeNode)
            }
        } else {
            treeNode.expanded = true
            self.specilaNode = treeNode
            manager.updateIndexPaths(indexPath.section, specilaNode: specilaNode)
            var insertionNodes: [ZNKTreeNode] = []
            treeNode.visibleTreeNode(&insertionNodes)
            for insertionNode in insertionNodes {
                print("insertionNode indexPath ===> \(insertionNode.indexPath) ====> identifier \(insertionNode.item.identifier) ===> expanded ===> \(insertionNode.expanded)")
            }
            let insertionIndexPaths = insertionNodes.compactMap({$0.indexPath})

            batchUpdates(.insertion, indexPaths: insertionIndexPaths)
            self.specilaNode = nil
            return
            if let delegate = delegate {
                if delegate.treeView(self, canExpandItem: treeNode.item) {
                    expandItemForTreeNode(treeNode)
                }
            } else {
                expandItemForTreeNode(treeNode)
            }
        }

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, heightfor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return 0
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, willDisplay: cell, for: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, willDisplayHeaderView: view, for: section)
        }
    }

    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, willDisplayFooterView: view, for: section)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didEndDisplaying: cell, for: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplayingHeaderView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, didEndDisplayingHeaderView: view, for: section)
        }
    }

    func tableView(_ tableView: UITableView, didEndDisplayingFooterView view: UIView, forSection section: Int) {
        if let delegate = delegate {
            delegate.treeView(self, didEndDisplayingFooterView: view, for: section)
        }
    }


    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, heightForHeaderIn: section)
        }
        return 45
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, heightForFooterIn: section)
        }
        return 45
    }



    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, estimatedHeightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return 45
    }


    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, estimatedHeightForHeaderIn: section)
        }
        return 45
    }

    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        if let delegate = delegate {
            return delegate.treeView(self, estimatedHeightForFooterIn: section)
        }
        return 45
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let delegate = delegate {
            return delegate.treeView(self, viewForHeaderIn: section)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let delegate = delegate {
            return delegate.treeView(self, viewForFooterIn: section)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, accessoryButtonTappedFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }



    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldHighlightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didHighlightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didUnhighlightFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }


    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if let delegate = delegate {
            let node = manager?.treeNodeForIndexPath(indexPath)
            if let _ = delegate.treeView(self, willSelect: node?.item) {
                return node?.indexPath
            }
        }
        return indexPath
    }


    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        if let delegate = delegate {
            let node = manager?.treeNodeForIndexPath(indexPath)
            if let _ = delegate.treeView(self, willDeselect: node?.item) {
                return node?.indexPath
            }
        }
        return indexPath
    }



    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, didDeselect: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }


    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if let delegate = delegate {
            return delegate.treeView(self, editingStyleFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return .none
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        if let delegate = delegate {
            return delegate.treeView(self, titleForDeleteConfirmationButtonFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if let delegate = delegate {
            return delegate.treeView(self, editActionsFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }


    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let delegate = delegate {
            return delegate.treeView(self, leadingSwipeActionsConfigurationFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if let delegate = delegate {
            return delegate.treeView(self, trailingSwipeActionsConfigurationFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldIndentWhileEditingFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return true
    }


    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            delegate.treeView(self, willBeginEditingFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }


    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        if let delegate = delegate {
            if let indexPath = indexPath {
                delegate.treeView(self, didEndEditingFor: manager?.treeNodeForIndexPath(indexPath)?.item)
            } else {
                delegate.treeView(self, didEndEditingFor: nil)
            }
        }
    }


    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if let delegate = delegate {
            let sourceNode = manager?.treeNodeForIndexPath(sourceIndexPath)
            let proposedDestinationNode = manager?.treeNodeForIndexPath(proposedDestinationIndexPath)
            let sourceItem = sourceNode?.item
            let destinationItem = proposedDestinationNode?.item
            if let item = delegate.treeView(self, targetItemForMoveFrom: sourceItem, toProposed: destinationItem) {
                return manager?.treeNodeForItem(item, at: nil)?.indexPath ?? proposedDestinationIndexPath
            }
        }
        return proposedDestinationIndexPath
    }



    func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if let delegate = delegate {
            return delegate.treeView(self, indentationLevelFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return 0
    }


    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldShowMenuFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }

    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, canPerformAction: action, for: manager?.treeNodeForIndexPath(indexPath)?.item, withSender: sender)
        }
        return false
    }

    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if let delegate = delegate {
            delegate.treeView(self, performAction: action, for: manager?.treeNodeForIndexPath(indexPath)?.item, with: sender)
        }
    }


    func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, canFocus: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return true
    }

    func tableView(_ tableView: UITableView, shouldUpdateFocusIn context: UITableViewFocusUpdateContext) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldUpdateFocusIn: context)
        }
        return true
    }


    func tableView(_ tableView: UITableView, didUpdateFocusIn context: UITableViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let delegate = delegate {
            delegate.treeView(self, didUpdateFocusIn: context, with: coordinator)
        }
    }

    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        if let delegate = delegate, let item = delegate.itemForPreferredFocusedView(in: self) {
            return manager?.treeNodeForItem(item, at: nil)?.indexPath
        }
        return nil
    }

    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, shouldSpringLoadRowAt indexPath: IndexPath, with context: UISpringLoadedInteractionContext) -> Bool {
        if let delegate = delegate {
            return delegate.treeView(self, shouldSpringLoad: manager?.treeNodeForIndexPath(indexPath)?.item, with: context)
        }
        return false
    }

}

//MARK: *************** UITableViewDataSource ****************
extension ZNKTreeView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfRootItemInTreeView(self) ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return manager?.numberOfVisibleNodeAtIndex(section, specilaNode: self.specilaNode) ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dataSource?.treeView(self, cellFor: manager?.treeNodeForIndexPath(indexPath)?.item, at: indexPath) ?? .init()
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let dataSource = dataSource {
            dataSource.treeView(self, commit: editingStyle, for: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let dataSource = dataSource {
            return dataSource.treeView(self, canEditFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }


    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let dataSource = dataSource {
            return dataSource.treeView(self, titleForHeaderInRootIndex: section)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if let dataSource = dataSource {
            return dataSource.treeView(self, titleForFooterInRootIndex: section)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if let dataSource = dataSource {
            return dataSource.treeView(self, canMoveFor: manager?.treeNodeForIndexPath(indexPath)?.item)
        }
        return false
    }



    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        if let dataSource = dataSource {
            return dataSource.sectionIndexTitles(for: self)
        }
        return nil
    }


    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.treeView(self, sectionForSectionIndexTitle: title, at: index)
        }
        return -1
    }



    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if let dataSource = dataSource {
            dataSource.treeView(self, moveItemAt: sourceIndexPath, to: destinationIndexPath)
        }
    }
}

extension ZNKTreeView: ZNKTreeNodeControllerDelegate {

    func numberOfRootNode() -> Int {
        return dataSource?.numberOfRootItemInTreeView(self) ?? 0
    }

    func numberOfChildrenForNode(_ node: ZNKTreeNode?, at rootIndex: Int) -> Int {
        return dataSource?.treeView(self, numberOfChildrenFor: node?.item, at: rootIndex) ?? 0
    }

    func treeNode(at childIndex: Int, of node: ZNKTreeNode?, at rootIndex: Int) -> ZNKTreeNode? {
        if let item = dataSource?.treeView(self, childIndex: childIndex, ofItem: node?.item, at: rootIndex) {
            return ZNKTreeNode.init(item: item, parent: node, indexPath: IndexPath.init(row: -1, section: rootIndex))
        } else {
            return nil
        }
    }

}


