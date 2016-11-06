//
//  APIManager.swift
//  NASA_APOD
//
//  Created by Ana Ma on 11/5/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class APIManager {
    
    internal static let manager : APIManager = APIManager()
    
    private init (){}
    
    func getData(from endpoint: String, complete: @escaping ((Data?)-> Void)){
        
        guard let url = URL(string: endpoint) else {return}
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error)
            }
            
            guard let validData = data else { return }
            
            complete(validData)
            
        }.resume()
        
    }
    
}
