//
//  APIRequestManager.swift
//  NASA APOD
//
//  Created by Annie Tung on 11/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

class APIRequestManager {
    static let manager: APIRequestManager = APIRequestManager()
    private init() {}
    
    func getData(APIEndPoint: String, callback: @escaping ((Data?) -> Void)) {
        guard let url = URL(string: APIEndPoint) else { return }
        
        let session = URLSession.init(configuration: .default)
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("Error encountered at \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            
            }.resume()
    }
}
