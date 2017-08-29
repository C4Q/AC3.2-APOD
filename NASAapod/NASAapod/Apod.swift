//
//  Apod.swift
//  NASAapod
//
//  Created by Ilmira Estil on 11/6/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation



class Apod {
    internal let title: String
    internal let date: String
    internal let explanation: String
    internal let mediaType: String
    internal let hdURL: String
    internal let regURL: String
    static let endpoint = "https://api.nasa.gov/planetary/apod?api_key=j3aX8H1ljxDukReFxz4Xff0HBbqcz72AwKHR0m7u&date="
    
    
    init(title: String, date: String, explanation: String, mediaType: String, hdURL: String, regURL: String) {
        self.title = title
        self.date = date
        self.explanation = explanation
        self.mediaType = mediaType
        self.hdURL = hdURL
        self.regURL = regURL
    }
    
    
    static func getApodData(from data: Data) -> Apod? {

        var randomApod: Apod?
        do {
            let data: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = data as? [String:Any]
                else {
                    print("error in dataDict")
                    return nil
            }
            guard let date = dict["date"] as? String,
                let explanation = dict["explanation"] as? String,
                let mediaType = dict["media_type"] as? String,
                let hdurl = dict["hdurl"] as? String,
                let regurl = dict["url"] as? String,
                let title = dict["title"] as? String
                else {
                    print("error in parsing")
                    return nil
            }
            
            randomApod = Apod.init(title: title, date: date, explanation: explanation, mediaType: mediaType, hdURL: hdurl, regURL: regurl)
            
        } catch let error as NSError {
            print("error here \(error)")
            return nil
        }
        return randomApod
    }
    
  
    
    
   
}
