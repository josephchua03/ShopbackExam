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

class DetailViewModel {
    
    var movieID = BehaviorRelay(value: "")
    
    //Call Service for Details
    func send<T: Codable>(movieID: String) -> Observable<T> {
        return Observable<T>.create { observer in
            
            let url = URL(string: Constants.MovieDetailURL +
                movieID +
                "?api_key=" + Constants.APIKey)
            
            let request = URLRequest(url: url!)
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                do {
                    let model: T = try JSONDecoder().decode(T.self, from: data ?? Data())
                    observer.onNext(model)
                } catch let error {
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
}


