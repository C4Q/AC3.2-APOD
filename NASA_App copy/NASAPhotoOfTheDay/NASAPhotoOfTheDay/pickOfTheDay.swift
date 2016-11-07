//
//  pickOfTheDay.swift
//  NASAPhotoOfTheDay
//
//  Created by Amber Spadafora on 11/5/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

internal enum DataParseError: Error {
    case results
    case name
}

class nasaPicture {
    
    var date: String
    var summary: String
    var media: String
    var title: String
    var url: String
    
    
    init(date: String, summary: String, media: String, title: String, url: String) {
        self.date = date
        self.summary = summary
        self.media = media
        self.title = title
        self.url = url
    }
    
    convenience init?(from dictionary: [String: String]) {
        
        
        guard let day = dictionary["date"] else {
            return nil
        }
        
        guard let sum = dictionary["explanation"] else {
            return nil
        }
        
        guard let med = dictionary["media_type"] else {
            return nil
        }
        guard let titl = dictionary["title"] else {
            return nil
        }
        
        guard let urll = dictionary["url"] else {
            return nil
        }
        
        self.init(date: day, summary: sum, media: med, title: titl, url: urll)
    }
    
    
    static func createPic(from data: Data) -> nasaPicture? {
        
        var pOD: nasaPicture?
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String: String] = jsonData as? [String: String]
                else {
                   throw DataParseError.results
                }
            
            
            let validPic: nasaPicture = nasaPicture(from: response)!
            pOD = validPic
            print(pOD?.title)
        
        }
            
        catch DataParseError.results {
            print("Error encountered with parsing 'results' key")
        }
            
        catch DataParseError.name {
            print("Error encountered with parsing 'names' key")
        }
            
        catch {
            print("Error encountered with parsing: \(error)")
        }
        
        return pOD
    }
    
    
    
    
}

