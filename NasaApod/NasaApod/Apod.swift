//
//  Apod.swift
//  NasaApod
//
//  Created by Sabrina Ip on 11/5/16.
//  Copyright © 2016 Sabrina Ip. All rights reserved.
//

import Foundation

enum ParseError: Error {
    case jsonSerialization
    case jsonParsing
}

class Apod {
    let date: String
    let imageUrlString: String
    let title: String
    let explanation: String
    let copyright: String?
    
    init(date: String, imageUrlString: String, title: String, explanation: String, copyright: String?) {
        self.date = date
        self.imageUrlString = imageUrlString
        self.title = title
        self.explanation = explanation
        self.copyright = copyright
    }
    
    static func getDataFromJson(data: Data) -> Apod? {
        var apodObject: Apod?
        
        do {
            let jsonData = try? JSONSerialization.jsonObject(with: data, options: [])
            guard let response = jsonData as? [String: String] else {
                throw ParseError.jsonSerialization
            }
            
            guard let date = response["date"],
                let imageUrlString = response["url"],
                let title = response["title"],
                let explanation = response["explanation"]
                else { throw ParseError.jsonParsing }
            
            var copyright: String?
            if let copyrightExists = response["copyright"] {
                copyright = copyrightExists
            }
            
            apodObject = Apod(date: date, imageUrlString: imageUrlString, title: title, explanation: explanation, copyright: copyright)
            
        } catch ParseError.jsonSerialization {
            print("JSON serialization error")
        } catch ParseError.jsonParsing {
            print("JSON parsing error")
        } catch {
            print(error)
        }
        return apodObject
    }
}
