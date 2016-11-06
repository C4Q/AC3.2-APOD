//
//  APODViewController.swift
//  NASAAPOD
//
//  Created by Madushani Lekam Wasam Liyanage on 11/5/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit

class APODViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var APODImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    
    var apod: APOD?
    let apodAPIEndPoint = "https://api.nasa.gov/planetary/apod?date="
    let apiKey = "&api_key=815Vu0CBdkUkn9mxQptiTH5i7qBSkKGJ0Z7xpFBf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionScrollView.delegate = self
        
        let imageString = apod?.image
        APODImage.image = UIImage(named: "no_preview")
        self.titleLabel.text = self.apod?.title
        self.descriptionLabel.text = self.apod?.description
        
        if apod?.mediaType == "image" {
            APIRequestManager.manager.getData(endPoint: imageString! ) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        self.APODImage.image = validImage
                        
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func datePicked(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.calendar = datePicker.calendar
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        let  dateString = formatter.string(from: datePicker.date)
        
        APIRequestManager.manager.getData(endPoint: apodAPIEndPoint+dateString+apiKey) { (data: Data?) in
            if  let validData = data,
                let validAPOD = APOD.getAPOD(from: validData) {
                self.apod = validAPOD
                
                DispatchQueue.main.async {
                    self.viewDidLoad()
                }
            }
        }
        
    }
    
}
