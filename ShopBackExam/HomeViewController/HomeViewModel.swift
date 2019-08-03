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
    
    static var canCallService = true
    static var maxPage = 1
    var currentPage = 1
    let pageNumber = BehaviorRelay(value:"1")
    static var allMoviesList: [Result] = []
    
    lazy var data: Driver<[Result]> = {
        return self.pageNumber.asObservable()
            .throttle(0.3, latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
//            .distinctUntilChanged({_,_ in })
            .flatMap(HomeViewModel.moviesBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func moviesBy(_ pageNumber: String) -> Observable<[Result]> {
        
        guard !pageNumber.isEmpty &&
            HomeViewModel.canCallService,
            let url = URL(string: Constants.MovieListURL +
                "?api_key=" + Constants.APIKey +
                "&sort_by=" + "release_date.desc" +
                "&page=" + pageNumber) else {
                return Observable.just([])
        }
        
         URLSession.shared.rx.data(request: URLRequest(url: url))
            .map(parse)
            .retry(3)
            .subscribe(onNext: { (r) in
            allMoviesList.append(contentsOf: r)
            }, onCompleted: {
                HomeViewModel.canCallService = true
        })
        
        return Observable.just(allMoviesList)
    }
    
    //Parse data from service of movie list
    static func parse(json: Any) -> [Result] {
        
        var movieDataList = [Result]()
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(MovieListData.self, from:
                json as! Data) //Decode JSON Response Data
            HomeViewModel.maxPage = model.totalPages
            movieDataList = model.results
            
        } catch let parsingError {
            print("Error", parsingError)
        }
        
        return movieDataList
    }
    
    //Call service if pull to refresh or inifinite scroll
    func callNextList(refresh:Bool = false){
        
        if refresh {
            currentPage = 1
        }
        else {
            currentPage += 1
        }
        pageNumber.accept(String(currentPage))
    }

}
