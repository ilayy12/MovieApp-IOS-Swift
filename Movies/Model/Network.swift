//
//  Network.swift
//  Movies
//
//  Created by aytü on 27.07.2022.
//

import Foundation
import Alamofire
import Kingfisher

struct Network {
    static let apiKey = "?api_key=86efe38563d8f3889183449e7c17e008"
    static let movieDB = "https://api.themoviedb.org/3"
    static let moviePopular = "/movie/popular"
    static let movieDetails = "/movie/" // {movie_id}
    static let cast = "/credits" // +movieDetails
    static let recommendations = "/recommendations" // +movieDetails
    static let searchMovie = "/search/movie"
    static let castDetails = "/person/" // {person_id}
    static let page = "&page="
    static let language = "&language="
    static let english = "en-US"
    static let turkish = "tr-TR"
    static let query = "&query="
}

class MoviesPopular {
    static let shared = MoviesPopular()
    var ispagination = false
    var setLang: String = Network.english
    
    private init () {}
    
    func getMoviePopular(lang: String, pagination: Bool = false, pageNo: Int, completion: @escaping (Result<PopularMovies, AFError>) -> Void) {
        if pagination {
            self.ispagination = true
        }
        if lang == "tr" {
            setLang = Network.turkish
        }
        let url = "\(Network.movieDB)"+"\(Network.moviePopular)"+"\(Network.apiKey)"+"\(Network.page)"+"\(pageNo)"+"\(Network.language)"+setLang
        AF.request(url, method: .get).responseDecodable(of: PopularMovies.self){
            response in completion(response.result)
            if pagination {
                self.ispagination = false
            }
        }
    }
}

class DetailsInfo {
    static let shared = DetailsInfo()
    var setLang: String = Network.english

    private init () {}
    
    func getDetails(lang: String, id: Int, completion: @escaping (Result<MovieDetails,AFError>) -> Void) {
        if lang == "tr" {
            setLang = Network.turkish
        }
        let url = "\(Network.movieDB)"+"\(Network.movieDetails)"+"\(id)"+"\(Network.apiKey)"+"\(Network.language)"+setLang
        AF.request(url, method: .get).responseDecodable(of: MovieDetails.self){
            response in completion(response.result)
        }
    }
}

class CastInfo {
    static let shared = CastInfo()
    var setLang: String = Network.english
    
    private init () {}
    
    func getCast(lang: String, id: Int, completion: @escaping (Result<Cast,AFError>) -> Void) {
        if lang == "tr" {
            setLang = Network.turkish
        }
        let url = "\(Network.movieDB)"+"\(Network.movieDetails)"+"\(id)"+"\(Network.cast)"+"\(Network.apiKey)"+"\(Network.language)"+setLang
        AF.request(url, method: .get).responseDecodable(of: Cast.self){
            response in completion(response.result)
        }
    }
}

class CastDetailsInfo {
    static let shared = CastDetailsInfo()
    var setLang: String = Network.english

    private init () {}
    
    func getCastDetails(lang: String, id: Int, completion: @escaping (Result<PersonDetails,AFError>) -> Void) {
        if lang == "tr" {
            setLang = Network.turkish
        }
        let url = "\(Network.movieDB)"+"\(Network.castDetails)"+"\(id)"+"\(Network.apiKey)"+"\(Network.language)"+setLang
        AF.request(url, method: .get).responseDecodable(of: PersonDetails.self){
            response in completion(response.result)
        }
    }
}

class SearchedInfo {
    static let shared = SearchedInfo()
    var ispagination = false
    var setLang: String = Network.english

    private init () {}

    func getSearched(lang: String, pagination: Bool = false, pageNo: Int, query: String, completion: @escaping (Result<SearchedMovies,AFError>) -> Void) {
        if pagination {
            self.ispagination = true
        }
        if lang == "tr" {
            setLang = Network.turkish
        }
        let url = "\(Network.movieDB)"+"\(Network.searchMovie)"+"\(Network.apiKey)"+"\(Network.language)"+setLang+"\(Network.query)"+"\(query)"+"\(Network.page)"+"\(pageNo)"
        AF.request(url, method: .get).responseDecodable(of: SearchedMovies.self){
            response in completion(response.result)
            if pagination {
                self.ispagination = false
            }
        }
    }
}

class RecsInfo {
    static let shared = RecsInfo()
    var ispagination = false
    var setLang: String = Network.english

    private init () {}
    
    func getRecs(lang: String, pagination: Bool = false, id: Int, pageNo: Int, completion: @escaping (Result<PopularMovies, AFError>) -> Void) {
        if pagination {
            self.ispagination = true
        }
        if lang == "tr" {
            setLang = Network.turkish
        }
        let url = "\(Network.movieDB)"+"\(Network.movieDetails)"+"\(id)"+"\(Network.recommendations)"+"\(Network.apiKey)"+"\(Network.page)"+"\(pageNo)"+"\(Network.language)"+setLang
        AF.request(url, method: .get).responseDecodable(of: PopularMovies.self){
            response in completion(response.result)
            if pagination {
                self.ispagination = false
            }
        }
    }
}
