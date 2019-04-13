//
//  File.swift
//  APOD
//
//  Created by Tong Lin on 11/6/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

internal class APIManager{
    
    internal static let manager = APIManager()
    init() {}
    
    //Request API
    func getAPOD(apiKey key: String, at date: String, callback: @escaping ((Data?) -> Void)) {
        let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=\(key)&date=\(date)")!
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil{
                print("getAPOD func triggered\(error!)")
            }
            
            if data != nil{
                callback(data)
            }
        }.resume()
    }
    
    func downloadImage(urlString: String, callback: @escaping (Data) -> () ) {
        
        guard let imageURL = URL(string: urlString) else { return }
        let session = URLSession.shared
        session.dataTask(with: imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered!: \(error!)")
            }
            guard let imageData = data else { return }
            callback(imageData)
            }.resume()
    }
    
    
}
