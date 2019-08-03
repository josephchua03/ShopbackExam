//
//  ViewController.swift
//  ShopBackExam
//
//  Created by Joseph Chua on 1/8/19.
//  Copyright © 2019 Joseph Chua. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    var refreshControl = UIRefreshControl()
    var homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        mainTableView.addSubview(refreshControl)
        
        homeViewModel.data
            .drive(mainTableView.rx.items(cellIdentifier: "HomeListTableCell",cellType: HomeListTableCell.self)) { _, movieData, cell in
                
                cell.lblTitle?.text = movieData.title
            }
            .disposed(by: disposeBag)
        
    }

    @objc func refresh(){
        homeViewModel.callRefresh()
        refreshControl.endRefreshing()
    }

    
}

