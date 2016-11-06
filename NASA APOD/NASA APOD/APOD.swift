//
//  APOD.swift
//  NASA APOD
//
//  Created by Harichandan Singh on 11/6/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

enum ParsingErrors: Error {
    case castingError, titleError, urlError, mediaTypeError
}

internal struct APOD {
    //MARK: - Properties
    var title: String
    var urlString: String
    var mediaType: String
    
    static func turnDataIntoAPOD(from data: Data) -> APOD? {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dict = jsonData as? [String: String] else {
                throw ParsingErrors.castingError
            }
            print("Successfully casted data from API.")
            
            guard let title = dict["title"] else {
                throw ParsingErrors.titleError
            }
            
            guard let urlString = dict["url"] else {
                throw ParsingErrors.urlError
            }
            
            guard let mediaType = dict["media_type"] else {
                throw ParsingErrors.mediaTypeError
            }
            
            let apod = APOD(title: title, urlString: urlString, mediaType: mediaType)
            
            return apod
            
        }
        catch ParsingErrors.castingError {
            print("There was an error casting from the JSON data.")
        }
        catch ParsingErrors.titleError {
            print("There was an error finding the title key.")
        }
        catch ParsingErrors.urlError {
            print("There was an error finding the url key.")
        }
        catch ParsingErrors.mediaTypeError {
            print("There was an error finding the media_type key.")
        }
        catch {
            print("There was an unexpected error!")
        }
        return nil
    }
}
