//
//  MovieModel.swift
//  PFE_6511483
//
//  Created by Swan Nay Phue Aung on 02/10/2024.
//

import Foundation

struct MovieResponse : Codable {
    let movies : [MovieModel]
}

struct MovieModel : Codable {
    let id : Int
    let poster_url : String
    let title_en : String
    let release_date : String
    let genre : String
    let duration : Int
    let synopsis_en : String
    let widescreen_url : String?
    let tr_mp4 : String?
    let now_showing : String?
}
