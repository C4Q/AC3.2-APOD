//
//  APOD.swift
//  APOD
//
//  Created by Jason Gresh on 11/7/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

enum APODError : String, Error {
    case image = "Missing image"
    case noType = "No type information"
    case unsupportedType = "Unsupported type"
}

class APOD {
//    {
//    "copyright": "Mark Hersch",
//    "date": "2016-11-07",
//    "explanation": "How could that city be upside-down? The city, Chicago, was actually perfectly right-side up. The long shadows it projected onto nearby Lake Michigan near sunset, however, when seen in reflection, made the buildings appear inverted. This fascinating, puzzling, yet beautiful image was captured by a photographer in 2014 on an airplane on approach to Chicago's O'Hare International Airport.  The Sun can be seen both above and below the cloud deck, with the later reflected in the calm lake.  As a bonus, if you look really closely -- and this is quite a challenge -- you can find another airplane in the image, likely also on approach to the same airport.",
//    "hdurl": "http://apod.nasa.gov/apod/image/1611/ChicagoClouds_Hersch_3600.jpg",
//    "media_type": "image",
//    "service_version": "v1",
//    "title": "Inverted City Beneath Clouds",
//    "url": "http://apod.nasa.gov/apod/image/1611/ChicagoClouds_Hersch_960.jpg"
//    }
    var copyright: String?
    var date: Date?
    var explanation: String?
    var mediaType: String
    var title: String?
    var bestUrlString: String
    
    init(dict: [String:AnyObject]) throws {
        guard let mediaType = dict["media_type"] as? String else {
            throw APODError.noType
        }
        guard  mediaType == "image" else {
            throw APODError.unsupportedType
        }
        
        self.mediaType = mediaType
        
        // the image url is the only required field
        // also we might find it in more than one place
        // let's pick the smaller one cos hd is slow
        var urlString : String!
        if let url = dict["url"] as? String {
            urlString = url
        }
        else if let url = dict["hdurl"] as? String {
            urlString = url
        }
        guard urlString != nil else { throw APODError.image }
        self.bestUrlString = urlString
        
        // from here on out we just take what we can
        if let copyright = dict["copyright"] as? String {
            self.copyright = copyright
        }
        
        if let explanation = dict["explanation"] as? String {
            self.explanation = explanation
        }
        
        if let title = dict["title"] as? String {
            self.title = title
        }
    }
    
    static func apodFromData(data: Data) throws -> APOD? {
        do {
            if let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject] {
                let apod = try APOD(dict: jsonObject)
                return apod
            }
        }
        catch APODError.image {
            print(APODError.image.rawValue)
            throw APODError.image
        }
        catch APODError.unsupportedType {
            print(APODError.image.rawValue)
            throw APODError.unsupportedType
        }
        catch {
            print(error)
        }
        return nil
    }
}
