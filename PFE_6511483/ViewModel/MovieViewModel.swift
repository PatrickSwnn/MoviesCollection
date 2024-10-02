//
//  AlbumViewModekl.swift
//  SwiftMapPlayground
//
//  Created by Swan Nay Phue Aung on 01/10/2024.
//

import Foundation

class MovieViewModel {
    
    let apiManger = APIManager.shared


    private (set) var movies : [MovieModel]? = [] {
        didSet {
            self.onMoviesUpdate?()
        }
    }
    
    var onMoviesUpdate: (()->Void)?
    
    
    
    var nowShowingMovies: [MovieModel] {
           guard let movies = movies else { return [] }
           return movies.filter { movie in
               return movie.now_showing == "1" // Movies that are currently showing
           }
       }
       
       var upcomingMovies: [MovieModel] {
           guard let movies = movies else { return [] }
           return movies.filter { movie in
               return movie.now_showing != "1" // Movies that are upcoming
           }
       }
    
    init(){
        fetchMovies()
    }
    
    
    private func fetchMovies() {
        let url = "https://majorcineplex.com/apis/get_movie_available"
        apiManger.fetchData(from: url, expecting: MovieResponse.self) { result in
            
            switch result {
            case .success(let moviesData):
                self.movies = moviesData.movies
                print(self.movies?.first?.release_date)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    
    
}
