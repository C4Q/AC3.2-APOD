//
//  APIManager.swift
//  NASAapod
//
//  Created by Ilmira Estil on 11/6/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation


class APIRequestManager {
    static let manager = APIRequestManager()
    private init() {}
    
    
    func getData(endPoint: String, date: String, callback: @escaping (Data?) -> Void) {
        guard let URL = URL(string: endPoint+date) else {return}
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: URL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during sessoin: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
    
 
}
