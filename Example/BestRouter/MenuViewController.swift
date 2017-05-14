//
//  MenuViewController.swift
//  BestRouter
//
//  Created by Adam Cumiskey on 5/14/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import BlockDataSource
import Foundation


class MenuViewController: UITableViewController, TableViewReloadable {
    var dataSource: DataSource
    
    init(dataSource: DataSource) {
        self.dataSource = dataSource
        super.init(style: .grouped)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reload()
    }
}
