//
//  DetailViewController.swift
//  ShopBackExam
//
//  Created by Joseph Chua on 4/8/19.
//  Copyright © 2019 Joseph Chua. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DetailViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var detailViewModel = DetailViewModel()
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtViewSynopsis: UITextView!
    @IBOutlet weak var lblPopularity: UILabel!
    @IBOutlet weak var lblLanguage: UILabel!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var lblGenre: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        detailViewModel.movieID.asObservable().flatMap { (movieID) -> Observable<MovieDetailData> in
            self.detailViewModel.send(movieID: movieID)
            }.subscribe(onNext: { (movieData) in
                DispatchQueue.main.async {
                    self.lblTitle.text = movieData.title
                    self.lblPopularity.text = String(movieData.popularity ?? 0)
                    self.lblDuration.text = String(movieData.runtime ?? 0)
                    var language = ""
                    movieData.spokenLanguages.forEach {
                        language += $0.name + ","
                        
                    }
                    self.lblLanguage.text = language
                    
                    var genres = ""
                    movieData.genres.forEach {
                        genres += $0.name + ","
                        
                    }
                    self.lblGenre.text = genres
                    self.txtViewSynopsis.text = movieData.overview ?? ""
                    guard let poster =  movieData.posterPath else {
                         return 
                    }
                    let url = URL(string: Constants.ImageURL + poster)
                    self.imageViewPoster.kf.setImage(with: url)
                    
                }
                
            })
    }
    
    @IBAction func bookMoviePressed(_ sender: Any) {
        guard let url = URL(string: Constants.BookingURL) else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}
