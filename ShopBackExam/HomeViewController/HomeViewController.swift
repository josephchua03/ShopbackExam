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
            .drive(mainTableView.rx.items(cellIdentifier: "HomeListTableCell")) { _, movieData, cell in

            }
            .disposed(by: disposeBag)
        
//        homeViewModel.pageNumber.accept("1")
        homeViewModel.data.asDriver()
            .map { "\($0.count) Repositories" }
            .drive(navigationItem.rx.title)
            .disposed(by: disposeBag)
    }

    @objc func refresh(){
        refreshControl.endRefreshing()
    }

    
}

