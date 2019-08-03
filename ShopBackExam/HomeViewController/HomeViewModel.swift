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

    var currentPage = 1
    let pageNumber = BehaviorRelay(value: "1")
    lazy var data: Driver<[Result]> = {
        
        return self.pageNumber.asObservable()
            .throttle(0.3, latest: true, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .flatMapLatest(HomeViewModel.moviesBy)
            .asDriver(onErrorJustReturn: [])
    }()
    
    static func moviesBy(_ pageNumber: String) -> Observable<[Result]> {
        guard !pageNumber.isEmpty,
            let url = URL(string: Constants.APIURL +
                "?api_key=" + Constants.APIKey +
                "&sort_by=" + "release_date.desc" +
                "&page=" + pageNumber) else {
                return Observable.just([])
        }
        
        return URLSession.shared.rx.data(request: URLRequest(url: url))
            .retry(3)
            .map(parse)
    }
    
    static func parse(json: Any) -> [Result] {
        
        var movieDataList = [Result]()
        do {
            let decoder = JSONDecoder()
            let model = try decoder.decode(MovieData.self, from:
                json as! Data) //Decode JSON Response Data
            print(model.totalPages)
            movieDataList = model.results
            
        } catch let parsingError {
            print("Error", parsingError)
        }
        
        return movieDataList
    }
    
    func callNextList(){
        currentPage += 1
        pageNumber.accept(String(currentPage))
    }
    
    func callRefresh(){
        currentPage = 1
        pageNumber.accept(String(currentPage))
    }
}
