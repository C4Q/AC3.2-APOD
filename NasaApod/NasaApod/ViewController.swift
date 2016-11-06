//
//  ViewController.swift
//  NasaApod
//
//  Created by Sabrina Ip on 11/5/16.
//  Copyright © 2016 Sabrina Ip. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var apodImage: UIImageView!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var videoLinkTextView: UITextView!
    
    var apod: Apod?
    
    var selectedDate: String {
        return getDateString()
    }
    
    func getDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: datePicker.date)
    }
    
    var urlString: String {
        return "https://api.nasa.gov/planetary/apod?api_key=tIQIXlKIZEIlzfpT0wYF8Nlua6sVa1bITpLeb5Ik&date=" + self.selectedDate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.maximumDate = Date()
        loadData()
    }
    
    @IBAction func datePickerChanged(_ sender: AnyObject) {
        loadData()
    }
    
    func loadData() {
        resetData()
        APIRequestManager.manager.getData(endpoint: urlString) { (data) in
            if let validData = data {
                self.apod = Apod.getDataFromJson(data: validData)
                DispatchQueue.main.async {
                    if self.apod != nil {
                        self.loadImage()
                        if let explanationExists = self.apod?.explanation {
                            self.explanationLabel.text = explanationExists
                        }
                    } else {
                        self.explanationLabel?.text = "A picture does not exist for this day"
                    }
                    
                }
            }
        }
    }
    
    func loadImage() {
        if let existingImage = apod?.imageUrlString {
            APIRequestManager.manager.getData(endpoint: existingImage) { (data) in
                if let validData = data {
                    DispatchQueue.main.async {
                        if let validImage = UIImage(data: validData) {
                            self.apodImage.image = validImage
                        } else {
                            self.videoLinkTextView.text = existingImage
                        }
                    }
                }
            }
        }
    }
    
    func resetData() {
        apod = nil
        self.apodImage.image = nil
        self.explanationLabel.text = nil
        self.videoLinkTextView.text = nil
    }
    
}
