//
//  TreeNodeEnum.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/8/12.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

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
