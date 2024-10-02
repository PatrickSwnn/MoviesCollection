//
//  AlbumViewModekl.swift
//  SwiftMapPlayground
//
//  Created by Swan Nay Phue Aung on 01/10/2024.
//

import Foundation

class CinemaViewModel {
    
    let apiManger = APIManager.shared


    private (set) var cinemas : [CinemaModel]? = [] {
        didSet {
            self.onCinemasUpdate?()
        }
    }
    
    var onCinemasUpdate: (()->Void)?
    
    
    
   
    init(){
        fetchCinemas()
    }
    
    
    private func fetchCinemas() {
        let url = "https://www.majorcineplex.com/apis/get_cinema"
        apiManger.fetchData(from: url, expecting: CinemaResponse.self) { result in
            
            switch result {
            case .success(let cinemaData):
                self.cinemas = cinemaData.cinemas
                print(self.cinemas?.count)
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    
    
}

