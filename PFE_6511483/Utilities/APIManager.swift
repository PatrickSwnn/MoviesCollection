//
//  APIManager.swift
//  SwiftMapPlayground
//
//  Created by Swan Nay Phue Aung on 01/10/2024.
//

import Foundation
import Alamofire

struct APIManager {
    
    
    static let shared = APIManager()
    private init() {     }
    
    
    func fetchData<T: Decodable>(from url: String, expecting type: T.Type, completion: @escaping (Result<T, AFError>) -> Void) {
        
        // Perform the request
        AF.request(url, method: .get)
            .validate() // Ensures that the response is valid (HTTP status code 200-299)
            .responseDecodable(of: type) { response in
                switch response.result {
                case .success(let data):
                    completion(.success(data)) // Return the parsed data on success
                case .failure(let error):
                    completion(.failure(error)) // Return the error on failure
                }
            }
    }
    
}
