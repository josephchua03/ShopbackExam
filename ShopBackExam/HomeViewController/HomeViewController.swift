//
//  ViewController.swift
//  ShopBackExam
//
//  Created by Joseph Chua on 1/8/19.
//  Copyright © 2019 Joseph Chua. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var listItems = NSMutableArray()
    
    var refreshControl = UIRefreshControl()
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        mainTableView.addSubview(refreshControl)
        
    }

    @objc func refresh(){
        refreshControl.endRefreshing()
    }

    
}

