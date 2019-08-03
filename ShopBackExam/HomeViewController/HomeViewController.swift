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
import Kingfisher

class HomeViewController: UIViewController {
    
    var refreshControl = UIRefreshControl()
    var homeViewModel = HomeViewModel()
    let disposeBag = DisposeBag()
    @IBOutlet weak var mainTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindPullToRefresh()
        bindTableViewCell()
        bindTableView()
        bindTableViewSelectedItem()
    }

    func bindPullToRefresh(){
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        mainTableView.addSubview(refreshControl)
    }
    
    @objc func refresh(){
        homeViewModel.callNextList(refresh: true)
        refreshControl.endRefreshing()
    }
    
    func bindTableView(){
        mainTableView.rx.contentOffset
            .subscribe { _ in
                if self.mainTableView.isNearBottomEdge() &&
                    self.homeViewModel.currentPage < HomeViewModel.maxPage{
                    self.homeViewModel.callNextList()
                }
            }
            .disposed(by: disposeBag)
        
    }
    
    func bindTableViewSelectedItem(){
        mainTableView.rx.modelSelected(Result.self)
            .subscribe(onNext :{ [unowned self] data in
                
                let detailViewCont = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
                self.navigationController?.pushViewController(detailViewCont, animated:true)
                detailViewCont.detailViewModel.movieID.accept(String(data.id))
                
                
            }).disposed(by: disposeBag)
    }
    
    func bindTableViewCell(){
        homeViewModel.data
            .drive(mainTableView.rx.items(cellIdentifier: "HomeListTableCell",cellType: HomeListTableCell.self)) { _, movieData, cell in
                
                cell.lblTitle.text = movieData.title
                cell.lblPopularity.text = String(movieData.popularity)
                guard let posterPath = movieData.posterPath else{
                    return
                }
                let url = URL(string: Constants.ImageURL + posterPath)
                cell.imageViewPoster.kf.setImage(with: url)
            }
            .disposed(by: disposeBag)
    }
}

