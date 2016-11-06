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

//    {
//    "date": "2016-11-05",
//    "explanation": "Shot in Ultra HD, this stunning video can take you on a tour of the International Space Station. A fisheye lens with sharp focus and extreme depth of field provides an immersive visual experience of life in the orbital outpost. In the 18 minute fly-through, your point of view will float serenely while you watch our fair planet go by 400 kilometers below the seven-windowed Cupola, and explore the interior of the station's habitable nodes and modules from an astronaut's perspective. The modular International Space Station is Earth's largest artificial satellite, about the size of a football field in overall length and width. Its total pressurized volume is approximately equal to that of a Boeing 747 aircraft.",
//    "media_type": "video",
//    "service_version": "v1",
//    "title": "ISS Fisheye Fly-Through",
//    "url": "https://www.youtube.com/embed/DhmdyQdu96M?rel=0"
//    }
    
