//
//  NetworkManager.swift
//  RickAndMortyAPI
//
//  Created by Joel Villa on 12/03/26.
//

import UIKit
import Alamofire

class NetworkManager {

    func getData(name: String? = nil, url: String? = nil, completion: @escaping (Result<CharacterResponse, Error>) -> Void) {
        var urlString = ""
        
        if let urlPagination = url {
            urlString = urlPagination
        } else {
            urlString = "https://rickandmortyapi.com/api/character"
            if let name = name {
                urlString += "?name=\(name)"
            }
        }
        
        AF.request(urlString).responseDecodable(of: CharacterResponse.self) { response in
            
            switch response.result {
            case .success(let data):
                completion(.success(data))
                
            case .failure(let error):
                completion(.failure(error))
            
            }
        }
    }
    
}
