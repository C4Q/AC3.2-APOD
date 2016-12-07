//
//  Apod.swift
//  NASA_APOD
//
//  Created by Ana Ma on 11/5/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

enum ApodModelParseError: Error {
    case apodObject
    case dictionary
    case detail
    case copyright
    case date
    case explanation
    case hdurl
    case media_type
    case service_version
    case title
    case url
}

class Apod {
    let copyright: String?
    let date: String
    let explanation: String?
    let hdurl: String?
    let media_type: String
    let service_version: String?
    let title: String?
    let url: String?
    
    init(copyright: String?, date: String, explanation: String?, hdurl: String?, media_type: String, service_version: String?, title: String?, url: String?){
        self.copyright = copyright
        self.date = date
        self.explanation = explanation
        self.hdurl = hdurl
        self.media_type = media_type
        self.service_version = service_version
        self.title = title
        self.url = url
    }
    
    convenience init? (dict: [String: Any]) throws {
        guard let copyright = dict["copyright"] as? String? else { throw ApodModelParseError.copyright}
        guard let date = dict["date"] as? String  else { throw ApodModelParseError.date}
        guard let explanation = dict["explanation"] as? String? else { throw ApodModelParseError.explanation}
        guard let hdurlString = dict["hdurl"] as? String? else { throw ApodModelParseError.hdurl}
        guard let media_type = dict["media_type"] as? String else { throw ApodModelParseError.media_type}
        guard let service_version = dict["service_version"] as? String? else { throw ApodModelParseError.service_version}
        guard let title = dict["title"] as? String?  else { throw ApodModelParseError.title}
        guard let urlString = dict["url"] as? String? else { throw ApodModelParseError.url}
        //guard let hdurl = String(string: hdurlString) else {return nil}
        //guard let url = String(string: urlString) else {return nil}
        self.init(copyright: copyright, date: date, explanation: explanation, hdurl: hdurlString, media_type: media_type, service_version: service_version, title: title, url: urlString)
    }
    
    static func getAPOD (from data: Data) -> Apod? {
        do {
            guard let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                throw ApodModelParseError.dictionary
            }
            //dump(jsonData)
            guard let a = try Apod(dict: jsonData) else {
                throw ApodModelParseError.apodObject
            }
            //dump(a)
            return a
        }
        catch ApodModelParseError.detail {
            print("error in casting detail")
        }
        catch ApodModelParseError.dictionary{
            print("error in casting dictionary")
        }
        catch {
            print(error)
        }
        return nil
    }
    
    /*
     "copyright": "John Hayes",
     "date": "2016-11-02",
     "explanation": "The first hint of what will become of our Sun was discovered inadvertently in 1764. At that time, Charles Messier was compiling a list of diffuse objects not to be confused with comets. The 27th object on Messier's list, now known as M27 or the Dumbbell Nebula, is a planetary nebula, the type of nebula our Sun will produce when nuclear fusion stops in its core. M27 is one of the brightest planetary nebulae on the sky, and can be seen toward the constellation of the Fox (Vulpecula) with binoculars. It takes light about 1000 years to reach us from M27,  shown above in colors emitted by hydrogen and oxygen. Understanding the physics and significance of M27 was well beyond 18th century science. Even today, many things remain mysterious about bipolar planetary nebula like M27, including the physical mechanism that expels a low-mass star's gaseous outer-envelope, leaving an X-ray hot white dwarf.",
     "hdurl": "http://apod.nasa.gov/apod/image/1611/M27_Hayes_2623.jpg",
     "media_type": "image",
     "service_version": "v1",
     "title": "M27: The Dumbbell Nebula",
     "url": "http://apod.nasa.gov/apod/image/1611/M27_Hayes_960.jpg"
     */
}
