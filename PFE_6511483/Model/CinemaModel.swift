//
//  CinemaModel.swift
//  PFE_6511483
//
//  Created by Swan Nay Phue Aung on 02/10/2024.
//

import Foundation

struct CinemaResponse : Codable {
    let cinemas : [CinemaModel]
}

struct CinemaModel : Codable {
    let cinema_id : String
    let cinema_name_en : String
    let zone_name_en : String
    let cinema_content_main : String?
    let brand_name_en : String
    let cinema_tel : String?
    let cinema_office_hour_en : String?
    let cinema_content_detail1 : String?
}
