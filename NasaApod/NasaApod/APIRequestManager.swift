//
//  APIRequestManager.swift
//  NasaApod
//
//  Created by Sabrina Ip on 11/5/16.
//  Copyright © 2016 Sabrina Ip. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let manager = APIRequestManager()
    private init() {}
    
    func getData(endpoint: String, complete: @escaping (Data?) -> Void) {
        guard let url = URL(string: endpoint) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error)
            }
            guard let validData = data else {return}
            complete(validData)
            }.resume()
    }
}
