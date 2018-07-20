//
//  ViewController.swift
//  ZNKTreeView
//
//  Created by 黄漫 on 2018/7/19.
//  Copyright © 2018年 SunEee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var treeView: ZNKTreeView = {
        $0.delegate = self
        $0.dataSource = self
        return $0
    }(ZNKTreeView.init(frame: view.bounds, style: .plain))
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(treeView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: ZNKTreeViewDelete {

}

extension ViewController: ZNKTreeViewDataSource {
    func treeView(_ treeView: ZNKTreeView, numberOfChildrenForItem item: ZNKTreeItem, in section: Int) -> Int {
        return 0
    }

    func numberOfSectionInTreeView(_ treeView: ZNKTreeView) -> Int {
        return 5
    }
}

