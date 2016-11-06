//
//  APIManager.swift
//  NASAPhotoOfTheDay
//
//  Created by Amber Spadafora on 11/5/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class APIManager {
    
    static let manager = APIManager()
    private init() {}
    
    let apiEndPoint: URL = URL(string: "https://api.nasa.gov/planetary/apod?api_key=yC5ugtNAp2oIp5MQHbLYy2h0ni2283p6rK6Cx2iK")!
    
    let apiEndPointString: String = "https://api.nasa.gov/planetary/apod?api_key=yC5ugtNAp2oIp5MQHbLYy2h0ni2283p6rK6Cx2iK"
    
    
    func getData(callback: @escaping ((Data?) -> Void)) {
        
        let currentUrlSession = URLSession(configuration: URLSessionConfiguration.default)
        
        
        currentUrlSession.dataTask(with: APIManager.manager.apiEndPoint) {(data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("There was an error during session: \(error)")
            }
            
            if data != nil {
                callback(data)
                print("apiManagerwasSuccessful")
            }
        }
        .resume()
        
    }
    
    func getDataforChosenDate(date: String, callback: @escaping ((Data?) -> Void)) {
        
        let dateString = "&date=\(date)"
        let fullEndPointString = APIManager.manager.apiEndPointString + dateString
        let endPointURL: URL = URL(string: fullEndPointString)!
        
        
        let currentUrlSession = URLSession(configuration: URLSessionConfiguration.default)
        currentUrlSession.dataTask(with: endPointURL) { (data:Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print("There was an error during session: \(error)")
            }
            
            if data != nil {
                callback(data)
                print("api request with user's date was successful")
            }
        }
        .resume()
    }
    
        
    }
    
    
    
    
//    https://api.nasa.gov/planetary/apod?
//    
//    api_key=yC5ugtNAp2oIp5MQHbLYy2h0ni2283p6rK6Cx2iK
//    
//    &
//    
//    date=2016-06-16
    
    

