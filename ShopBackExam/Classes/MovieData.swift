//
//  MovieData.swift
//  ShopBackExam
//
//  Created by Joseph Chua on 3/8/19.
//  Copyright © 2019 Joseph Chua. All rights reserved.
//

import Foundation

struct MovieData: Codable {
    let page = 0, totalResults = 0, totalPages: Int = 0
    let results: [Result]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}

struct Result: Codable {
    let voteCount = 0, id: Int = 0
    let video: Bool = false
    let voteAverage: Int = 0
    var title: String = ""
    let popularity: Double = 0.0
    let posterPath: String? = ""
    let originalLanguage = "", originalTitle: String = ""
    let genreIDS: [Int] = []
    let backdropPath: String? = ""
    let adult: Bool = false
    let overview = "", releaseDate: String = ""
    
    enum CodingKeys: String, CodingKey {
        case voteCount = "vote_count"
        case id, video
        case voteAverage = "vote_average"
        case title, popularity
        case posterPath = "poster_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case genreIDS = "genre_ids"
        case backdropPath = "backdrop_path"
        case adult, overview
        case releaseDate = "release_date"
    }
}
