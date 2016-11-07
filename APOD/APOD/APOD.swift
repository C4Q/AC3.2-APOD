//
//  APOD.swift
//  APOD
//
//  Created by Tong Lin on 11/6/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation
/*
 {
 "copyright": "Robert Howell",
 "date": "2016-10-2",
 "explanation": "Sometimes both heaven and Earth erupt. Colorful aurorae erupted unexpectedly a few years ago, with green aurora appearing near the horizon and brilliant bands of red aurora blooming high overhead.  A bright Moon lit the foreground of this picturesque scene, while familiar stars could be seen far in the distance.  With planning, the careful astrophotographer shot this image mosaic in the field of White Dome Geyser in Yellowstone National Park in the western USA. Sure enough, just after midnight, White Dome erupted -- spraying a stream of water and vapor many meters into the air. Geyser water is heated to steam by scalding magma several kilometers below, and rises through rock cracks to the surface. About half of all known geysers occur in Yellowstone National Park. Although the geomagnetic storm that created these aurorae has since subsided, eruptions of White Dome Geyser continue about every 30 minutes.   Free Download: APOD 2017 Calendar: NASA Images",
 "hdurl": "http://apod.nasa.gov/apod/image/1610/geyseraurora_howell_2163.jpg",
 "media_type": "image",
 "service_version": "v1",
 "title": "Aurora Over White Dome Geyser",
 "url": "http://apod.nasa.gov/apod/image/1610/geyseraurora_howell_960.jpg"
 }
 */

internal struct APOD {
    internal let date: String
    internal let explanation: String
    internal let title: String
    internal let imageURL: String
    
    static func apod(from data: Data) -> APOD? {
        do {
            let rawData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let tempData: [String: Any] = rawData as? [String: Any] else {
                return nil
            }
            
            guard let date: String = tempData["date"] as? String else {
                return nil
            }
            
            guard let explanation: String = tempData["explanation"] as? String else {
                return nil
            }
            
            guard let title: String = tempData["title"] as? String else {
                return nil
            }
            
            guard let imageURL: String = tempData["url"] as? String else {
                return nil
            }
            
            let finalAPOD = APOD(date: date, explanation: explanation, title: title, imageURL: imageURL)
            
            return finalAPOD
        } catch  {
            print("data to APOD catch error")
        }
        return nil
    }
}
