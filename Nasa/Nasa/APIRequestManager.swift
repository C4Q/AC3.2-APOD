//
//  APIRequestManager.swift
//  Nasa
//
//  Created by Marcel Chaucer on 11/5/16.
//  Copyright © 2016 Marcel Chaucer. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let manager = APIRequestManager()
    private init (){}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myUrl = URL(string: endPoint) else {return}
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: myUrl) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
}

