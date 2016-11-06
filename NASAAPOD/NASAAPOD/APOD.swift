//
//  APOD.swift
//  NASAAPOD
//
//  Created by Madushani Lekam Wasam Liyanage on 11/5/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import Foundation

enum APODModelParseError: Error {
    case results(json: Any)
    case image(image: Any)
}


class APOD {
    
    let date: String
    let mediaType: String
    let image: String
    let title: String
    let description: String
    
    
    init(date: String, mediaType: String, image: String, title: String, description: String) {
        self.date = date
        self.mediaType = mediaType
        self.image = image
        self.title = title
        self.description = description
    }
    
    static func getAPOD(from data: Data) -> APOD? {
        var apodToReturn: APOD?
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String:AnyObject] = jsonData as? [String:AnyObject] else {
                throw APODModelParseError.results(json: jsonData)
                
            }
            if let date = response["date"] as? String,
                let mediaType = response["media_type"] as? String,
                let title = response["title"] as? String,
                let description = response["explanation"] as? String,
                let imageString = response["url"] as? String {
                
                apodToReturn = APOD.init(date: date, mediaType: mediaType, image: imageString, title: title, description: description)
            }
        }
        catch let APODModelParseError.results(json: json)  {
            print("Error encountered with parsing 'results' key for object: \(json)")
        }
        catch let APODModelParseError.image(image: im)  {
            print("Error encountered with parsing 'image': \(im)")
        }
        catch {
            print("Unknown parsing error")
        }
        
        return apodToReturn
    }
}


