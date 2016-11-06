//
//  APIRequestManager.swift
//  NASA APOD
//
//  Created by Harichandan Singh on 11/6/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

class APIRequestManager {
    //MARK: - Properties
    static let manager = APIRequestManager()
    
    //MARK: - Initializers
    private init() {}
    
    func getData(apiEndpoint: String, callback: @escaping (Data?) -> Void) {
        
        //1. get URL from apiEndpoint
        guard let url: URL = URL(string: apiEndpoint) else { return }
        
        //2.create URL Session
        let session: URLSession = URLSession.init(configuration: .default)
        
        //3.create task and pass data into closure
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Encountered an error: \(error)")
            }
            
            guard let jsonData = data else { return }
            
            callback(jsonData)
            
            }.resume()
    }
}
