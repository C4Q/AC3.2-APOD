//
//  NASA.swift
//  NASA APOD
//
//  Created by Annie Tung on 11/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

enum handleParseData: Error {
    case results, jsonSerialization
}

class Nasa {
    let date: String
    let explanation: String
    let title: String
    let url: String
    let mediaType: String
    
    init(date: String, explanation: String, title: String, url: String, mediaType: String) {
        self.date = date
        self.explanation = explanation
        self.title = title
        self.url = url
        self.mediaType = mediaType
    }
    
    static func generateNasa(data: Data?) -> [Nasa]? {
        var nasaToReturn = [Nasa]()
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data!, options: [])
            guard let response = jsonData as? [String:AnyObject] else { throw handleParseData.jsonSerialization }

                guard let date = response["date"] as? String,
                    let explanation = response["explanation"] as? String,
                    let title = response["title"] as? String,
                    let url = response["url"] as? String,
                    let mediaType = response["media_type"] as? String else { throw handleParseData.results }
            
            nasaToReturn.append(Nasa(date: date, explanation: explanation, title: title, url: url, mediaType: mediaType))
        } catch {
            print("Unknown parsing error at \(error)")
        }
        return nasaToReturn
    }
}
