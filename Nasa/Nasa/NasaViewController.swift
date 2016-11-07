//
//  ViewController.swift
//  Nasa
//
//  Created by Marcel Chaucer on 11/5/16.
//  Copyright © 2016 Marcel Chaucer. All rights reserved.
//

import UIKit

class NasaViewController: UIViewController {
    var nasaPicture: [Picture] = []
    
    
    @IBOutlet weak var imageOfTheDay: UIImageView!

    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var datePickerOutlet: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePickerOutlet.maximumDate = NSDate() as Date
        APIRequestManager.manager.getData(endPoint: "https://api.nasa.gov/planetary/apod?api_key=pNuRJUeMl4hkL3N00YGhPIvSGbKRiiY4FmaV3bnr") { (data: Data?) in
            if  let validData = data,
                let validInfo = Picture.getInfo(from: validData) {
                DispatchQueue.main.async {
                self.textView.text = validInfo[0].summary
                    if UIImage(data: validInfo[0].url) == nil {
                        self.imageOfTheDay.image = #imageLiteral(resourceName: "NasaLogo") }
                    else { self.imageOfTheDay.image = UIImage(data: validInfo[0].url)
                }
                }
            }
        }
        
    }
    
    
      @IBAction func datePick(_ sender: UIDatePicker) {
        let theDate = String(describing: datePickerOutlet.date)
        let fullDate = theDate.components(separatedBy: " ")[0]
        let apiEndpoint = "https://api.nasa.gov/planetary/apod?api_key=pNuRJUeMl4hkL3N00YGhPIvSGbKRiiY4FmaV3bnr&date=\(fullDate)"
        print(apiEndpoint)
        
        APIRequestManager.manager.getData(endPoint: apiEndpoint) { (data: Data?) in
            if  let validData = data,
                let validInfo = Picture.getInfo(from: validData)
            {
                DispatchQueue.main.async {
                    self.textView.text = validInfo[0].summary
                    if UIImage(data: validInfo[0].url) == nil {
                        self.imageOfTheDay.image = #imageLiteral(resourceName: "NasaLogo") } else {
                        self.imageOfTheDay.image = UIImage(data: validInfo[0].url)
                    }
                }
                

                
                
            }
        }
    }
}
