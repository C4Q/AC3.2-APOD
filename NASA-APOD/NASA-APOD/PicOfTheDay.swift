//
//  PicOfTheDay.swift
//  NASA-APOD
//
//  Created by Victor Zhong on 11/5/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

enum APODModelParseError: Error {
	case results(json: Any)
	case title(title: Any)
	case explanation(exp: Any)
	case url(url: Any)
	case hdurl(hdurl: Any)
	case media(type: Any)
	case date(date: Any)
	case image(image: Any)
}

class PicOfTheDay {
	let title:			String
	let explanation:	String
	let url:			String
	let media:			String //media_type
//	let hdUrl:			String // not used in this project
	
	init(
		title:			String,
		explanation:	String,
		url:			String,
		media:			String
//		hdUrl:			String
		) {
		self.title =		title
		self.explanation =	explanation
		self.url =			url
		self.media =		media
//		self.hdUrl =		hdUrl
	}
	
	convenience init?(from dictionary: [String:AnyObject]) throws {
		guard let title = dictionary["title"] as? String else {
			throw APODModelParseError.title(title: dictionary["title"] as Any)
		}
		
		guard let explanation = dictionary["explanation"] as? String else {
			throw APODModelParseError.explanation(exp: dictionary["explanation"] as Any)
		}
		
		guard let url = dictionary["url"] as? String else {
			throw APODModelParseError.url(url: dictionary["url"] as Any)
		}
		
		guard let media = dictionary["media_type"] as? String else {
			throw APODModelParseError.media(type: dictionary["media_type"] as Any)
		}
		
//		guard let hdUrl = dictionary["hdurl"] as? String else {
//			throw APODModelParseError.hdurl(hdurl: dictionary["hdurl"])
//		}

		
		self.init(title:		title,
		          explanation:	explanation,
		          url:			url,
		          media:		media
//		          hdUrl:		hdUrl
		)
	}
	
	static func getPic(from data: Data) -> [PicOfTheDay]? {
		var picToReturn: [PicOfTheDay]? = []
		
		do {
			let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
			
			guard let response: [String : AnyObject] = jsonData as? [String : AnyObject] else {
				throw APODModelParseError.results(json: jsonData)
			}
			
			if let pic = try PicOfTheDay(from: response) {
				picToReturn?.append(pic)
				print("We have APOD data!")
			}
		}
		catch let APODModelParseError.results(json: json)  {
			print("Error encountered with parsing 'Generic' or 'items' key for object: \(json)")
		}
		catch let APODModelParseError.image(image: im)  {
			print("Error encountered with parsing 'image': \(im)")
		}
		catch {
			print("Unknown parsing error: \(error)")
		}
		
		return picToReturn
	}
	
	
	
}

// Example calls and API references below
/*
date	YYYY-MM-DD	today	The date of the APOD image to retrieve
hd	bool	False	Retrieve the URL for the high resolution image
api_key	string	DEMO_KEY	api.nasa.gov key for expanded usage
*/

//a2Ik8CagrnE2JlQv8dRiu0VmYhLSy1A2fpPfmv3t
//
//api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=2016-11-04
//api.nasa.gov/planetary/apod?api_key=a2Ik8CagrnE2JlQv8dRiu0VmYhLSy1A2fpPfmv3t&date=2016-11-04

/*
{
copyright: "Ken Crawford",
date: "2016-11-04",
explanation: "Look through the cosmic cloud cataloged as NGC 281 and you might miss the stars of open cluster IC 1590. Still, formed within the nebula that cluster's young, massive stars ultimately power the pervasive nebular glow. The eye-catching shapes looming in this portrait of NGC 281 are sculpted columns and dense dust globules seen in silhouette, eroded by intense, energetic winds and radiation from the hot cluster stars. If they survive long enough, the dusty structures could also be sites of future star formation. Playfully called the Pacman Nebula because of its overall shape, NGC 281 is about 10,000 light-years away in the constellation Cassiopeia. This sharp composite image was made through narrow-band filters, combining emission from the nebula's hydrogen, sulfur, and oxygen atoms in green, red, and blue hues. It spans over 80 light-years at the estimated distance of NGC 281.",
hdurl: "http://apod.nasa.gov/apod/image/1611/PacmanCrawfordNew2048.jpg",
media_type: "image",
service_version: "v1",
title: "Portrait of NGC 281",
url: "http://apod.nasa.gov/apod/image/1611/PacmanCrawfordNew1024.jpg"
}
*/
