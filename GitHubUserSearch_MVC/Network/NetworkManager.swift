//
//  NetworkManager.swift
//  githubExample
//
//  Created by 신동규 on 29/04/2019.
//  Copyright © 2019 신동규. All rights reserved.
//

import Alamofire

class NetworkManager {
    
    func search(searchWord:String,searchPage:Int, completion: @escaping (SearchModel?,Error?) -> Void) {
        let url = "https://api.github.com/search/users?q=\(searchWord)&page=\(searchPage)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON {
                response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let join = try JSONDecoder().decode(SearchModel.self, from: data)
                            completion(join, nil)
                        } catch let error {
                        print(error)
                            completion(nil, error)
                        }
                    }
                    
                case .failure(let error):
                    print(error)
                    completion(nil, error)
                    
                }
                
        }
        
    }
    
}
