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
        
        return URLSession.shared.rx.json(url: url)
            .retry(3)
            .catchErrorJustReturn([])
            .map(parse)
    }
    
    static func parse(json: Any) -> [Result] {
        
//        do {
        
            var movieData = [Result]()
            let resultList = json as! Dictionary<String, Any>
            let arrayItems:NSArray = resultList["results"] as! NSArray
           arrayItems.forEach { item  in
                let itemValue = item as! Dictionary<String,Any>
                var res = Result()
                res.title = itemValue["title"] as! String
                movieData.append(res)
            }
            //here dataResponse received from a network request
//            let decoder = JSONDecoder()
//            let model = try decoder.decode(MovieData.self, from:
//                json as! Data) //Decode JSON Response Data
//            print(model.totalPages) //Output - 1221
            
//        } catch let parsingError {
//            print("Error", parsingError)
//        }
//
//        guard let items = json as? [[String: Any]]  else {
//            return []
//        }
//
//
//        items.forEach{
//            guard let repoName = $0["name"] as? String,
//                let repoURL = $0["html_url"] as? String else {
//                    return
//            }
//            movieData.append(MovieData(""))
//        }
        return movieData
    }
}
