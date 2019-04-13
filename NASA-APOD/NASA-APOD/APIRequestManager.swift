//
//  APIRequestManager.swift
//  NASA-APOD
//
//  Created by Victor Zhong on 11/5/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

class APIRequestManager {
	
	static let manager = APIRequestManager()
	private init() {}
	
	func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
		guard let myURL = URL(string: endPoint) else { return }
		let session = URLSession(configuration: URLSessionConfiguration.default)
		session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
			if error != nil {
				print("Error durring session: \(error)")
			}
			guard let validData = data else { return }
			callback(validData)
			}.resume()
	}
}
