//
//  ViewController.swift
//  NASA-APOD
//
//  Created by Victor Zhong on 11/5/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	@IBOutlet var tapGestureRecognizer: UITapGestureRecognizer!
	
	@IBOutlet weak var picLabel: UILabel!
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var picImage: UIImageView!
	
	@IBAction func dateSelected(_ sender: UIDatePicker) {
		date = chooseDate(date: sender.date)
		loadData(date: date)
	}
	
	var apiKey = "a2Ik8CagrnE2JlQv8dRiu0VmYhLSy1A2fpPfmv3t" // Fill out your own key here
	var apod: [PicOfTheDay]?
	var date = ""
	var dateFormat = Date()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		datePicker.maximumDate = NSDate() as Date
		loadData()
	}
	
	// MARK: - Load Data code
	func loadData(date: String = "") {
		//let escapedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
		APIRequestManager.manager.getData(endPoint: "https://api.nasa.gov/planetary/apod?api_key=\(apiKey)&date=\(date)") { (data: Data?) in
			if  let validData = data,
				let validPic = PicOfTheDay.getPic(from: validData) {
				self.apod = validPic
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
				
				// Switches images for if the Pic of the Day is an image or video.
				
				if dataLoaded[0].media == "image" {
					APIRequestManager.manager.getData(endPoint: dataLoaded[0].url) { (data: Data?) in
						if  let validData = data,
							let validImage = UIImage(data: validData) {
							DispatchQueue.main.async {
								self.picImage.image = validImage
								self.picImage.setNeedsLayout()
								if self.apiLabelSwap(date: self.datePicker.date) {
									self.picLabel.text = dataLoaded[0].title
								}
								else {
									self.picLabel.text = dataLoaded[0].explanation
								}
							}
						}
					}
				}
				else {
					DispatchQueue.main.async {
						self.picImage.image = #imageLiteral(resourceName: "video-thumbnail")
						self.picImage.setNeedsLayout()
						if self.apiLabelSwap(date: self.datePicker.date) {
							self.picLabel.text = dataLoaded[0].title
						}
						else {
							self.picLabel.text = dataLoaded[0].explanation
						}
					}
				}
			}
		}
	}
	
	//MARK: - Date-related functions
	// Returns Dates as Strings for both API calls and readability.
	
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
	
	// API calls before August 19, 1996 did not have legitimate titles, so we swap the label to explanations instead. To do so, we need to check if the date picked was before this time.
	
	func apiLabelSwap(date: Date) -> Bool {
		let dateformatter = DateFormatter()
		dateformatter.dateFormat = "yyyy-MM-dd"
		let dateFormatSwapped = dateformatter.date(from: "1996-08-19")
		return date.compare(dateFormatSwapped!) == .orderedDescending
	}
	
	//MARK: - Gesture Actions
	// Taps on image should only be detected when the Pic of the Day is a video.
	
	@IBAction func didPerformGesture(_ sender: UITapGestureRecognizer) {
		if let dataLoaded = self.apod {
			if dataLoaded[0].media != "image" {
				let urlString = URL(string: dataLoaded[0].url)
				UIApplication.shared.open(urlString!)
			}
		}
	}
}

