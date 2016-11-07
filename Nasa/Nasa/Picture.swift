//
//  Picture.swift
//  Nasa
//
//  Created by Marcel Chaucer on 11/5/16.
//  Copyright © 2016 Marcel Chaucer. All rights reserved.
//

import Foundation

class Picture {
    let date: String
    let summary: String
    let mediaType: String
    let title: String
    let url: Data
    
    init(date: String, summary: String, mediaType: String, title: String, url: Data) {
        self.date = date
        self.summary = summary
        self.mediaType = mediaType
        self.title = title
        self.url = url
    }
    
    convenience init?(withDict dict: [String:Any]) {
        if let date = dict["date"] as? String,
            let summary = dict["explanation"] as? String,
            let mediaType = dict["media_type"] as? String,
            let title = dict["title"] as? String,
            let urlString = dict["url"] as? String,
            let urlURL = URL(string: urlString),
            let url = try? Data(contentsOf: urlURL)
            
                    {
            self.init(date: date, summary: summary, mediaType: mediaType, title: title, url: url)
        }
        else {
            return nil
        }
    }

    static func getInfo(from data: Data) -> [Picture]? {
        var infoToReturn: [Picture]? = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let pictureInfo = jsonData as? [String:Any] else { return nil}
            
                if let picture = Picture(withDict: pictureInfo) {
                    infoToReturn?.append(picture)
                
            }
        }
        catch {
            print("Unknown parsing error")
        }
        
        return infoToReturn
    }
    
}




