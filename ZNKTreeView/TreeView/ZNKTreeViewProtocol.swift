//
//  ZNKTreeViewProtocol.swift
//  ZNKTreeView
//
//  Created by HuangSam on 2018/7/20.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

protocol ZNKTreeViewDelete {

}

protocol ZNKTreeViewDataSource {

    /// 视图分段数，默认1
    ///
    /// - Parameter treeView: 树形图
    /// - Returns: Int
    func numberOfSectionInTreeView(_ treeView: ZNKTreeView) -> Int

    
}

extension ZNKTreeViewDataSource {

    func numberOfSectionInTreeView(_ treeView: ZNKTreeView) -> Int {
        return 1
    }
}


