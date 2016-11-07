//
//  ViewController.swift
//  NASA-APOD
//
//  Created by Victor Zhong on 11/5/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet weak var picLabel: UILabel!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var picImage: UIImageView!
	@IBAction func dateSelected(_ sender: UIDatePicker) {
		date = chooseDate(date: sender.date)
		loadData(date: date)
	}
	
	func chooseDate(date: Date) -> String {
		let dateformatter = DateFormatter()
		dateformatter.dateFormat = "yyyy-MM-dd"
		return dateformatter.string(from: date)
	}
	
	func wrongDate(date: Date) -> String {
		let dateformatter = DateFormatter()
		dateformatter.dateFormat = "MMMM dd, yyyy"
		return dateformatter.string(from: date)
	}
	
	var apiKey = "a2Ik8CagrnE2JlQv8dRiu0VmYhLSy1A2fpPfmv3t"
	var apod: [PicOfTheDay]?
	var date = ""
	
	override func viewDidLoad() {
		super.viewDidLoad()
		datePicker.maximumDate = NSDate() as Date
		loadData()
	}
	
	func loadData(date: String = "") {
		//let escapedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		APIRequestManager.manager.getData(endPoint: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&date=\(date)") { (data: Data?) in
			if  let validData = data,
				let validPic = PicOfTheDay.getPic(from: validData) {
				self.apod = validPic
				//				DispatchQueue.main.async {
				//					self.tableView?.reloadData()
				//				}
			}
			
			if let dataLoaded = self.apod {
				guard dataLoaded.count != 0 else {
					DispatchQueue.main.async {
						self.picLabel.text = "There was no Pic of the Day on \(self.wrongDate(date: self.datePicker.date))."
						self.picImage.image = #imageLiteral(resourceName: "404page-complex")
						self.picImage.setNeedsLayout()
					}
					return
				}
				if dataLoaded[0].media == "image" {
					APIRequestManager.manager.getData(endPoint: dataLoaded[0].url) { (data: Data?) in
						if  let validData = data,
							let validImage = UIImage(data: validData) {
							DispatchQueue.main.async {
								self.picLabel.text = dataLoaded[0].title
								self.picImage.image = validImage
								self.picImage.setNeedsLayout()
							}
						}
					}
				}
				else {
					DispatchQueue.main.async {
						self.picLabel.text = dataLoaded[0].title
						self.picImage.image = #imageLiteral(resourceName: "video-thumbnail")
						self.picImage.setNeedsLayout()
					}
				}
			}
		}
	}
}

