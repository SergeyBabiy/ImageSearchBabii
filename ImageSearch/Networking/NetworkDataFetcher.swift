//
//  DataNetworkFetcher.swift
//  ImageSearch
//
//  Created by Сергей Бабий on 13.05.2021.
//

import Foundation

class NetworkDataFetcher {
    let networkService = NetworkService()    
    
    func fatchData(urlString: String, response: @escaping (SearchResponse?) -> Void)  {
        networkService.request(urlString: urlString) { (result) in
            switch result{
            case .success(let data):
                do {
                    let image = try JSONDecoder().decode(SearchResponse.self, from: data)
                    response(image)
                } catch let jsonError {
                    print("Faild to decode JSON: ", jsonError)
                    response(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                response(nil)
            }
        }
    }
}
