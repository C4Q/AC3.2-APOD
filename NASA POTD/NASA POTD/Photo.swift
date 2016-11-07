//
//  File.swift
//  NASA POTD
//
//  Created by C4Q on 11/6/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class Photo {
    
    let url: String
    let explanation: String
    
    init(url: String, explanation: String) {
        self.explanation = explanation
        self.url = url
    }
    
    convenience init? (dict: [String:String]){
   
        guard let url = dict["url"], let explanation = dict["explanation"] else {return nil}
        
        self.init(url: url, explanation: explanation)
        
    }
    
    static func parseData(data: Data) -> Photo? {
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: [])
            guard let dict = jsonData as? [String: String] else {print("dict failed")
                return nil}
            
            return Photo.init(dict: dict)
        }
        catch {
            print(error)
            return nil
        }
    }
}
