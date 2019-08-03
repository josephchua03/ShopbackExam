//
//  HomeViewModel.swift
//  ShopBackExam
//
//  Created by Joseph Chua on 3/8/19.
//  Copyright © 2019 Joseph Chua. All rights reserved.
//

import RxSwift
import RxCocoa
import Foundation

class HomeViewModel {

    let pageNumber = BehaviorRelay(value: "1")
    lazy var data: Driver<[MovieData]> = {
        
        return self.pageNumber.asObservable()
            .throttle(0.3, latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(HomeViewModel.moviesBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func moviesBy(_ pageNumber: String) -> Observable<[MovieData]> {
        guard !pageNumber.isEmpty,
            let url = URL(string: Constants.APIURL +
                "?api_key=" + Constants.APIKey +
                "&sort_by=" + "release_date.desc" +
                "&page=" + pageNumber) else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .catchErrorJustReturn([])
            .map(parse)
    }
    
    static func parse(json: Any) -> [MovieData] {
        guard let items = json as? [[String: Any]]  else {
            return []
        }
        
        var repositories = [MovieData]()
        
//        items.forEach{
//            guard let repoName = $0["name"] as? String,
//                let repoURL = $0["html_url"] as? String else {
//                    return
//            }
////            repositories.append(MovieData())
//        }
        return repositories
    }
}
