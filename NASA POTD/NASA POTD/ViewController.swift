//
//  ViewController.swift
//  NASA POTD
//
//  Created by C4Q on 11/6/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nasaImage: UIImageView!
    @IBOutlet weak var textLabel: UILabel!
    @IBAction func buttonPressed(_ sender: UIButton){
        UIApplication.shared.openURL(URL(string: photo!.url)!)
    }
    
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var chooseYourDate: UIDatePicker!
    
    var photo: Photo?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      //  updateViews(endPoint: "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=\(getDate(chooseYourDate.date))")
        
    }


    @IBAction func dateDidChange(_ sender: UIDatePicker) {
        
        let endPoint = "https://api.nasa.gov/planetary/apod?api_key=DEMO_KEY&date=\(getDate(sender.date))"
        self.button.isHidden = true
        self.nasaImage.isHidden = false
        
        APIManager.manager.getData(endPoint: endPoint) { (data: Data?) in
            if let d = data {
                self.photo = Photo.parseData(data: d)
                guard let photograph = self.photo else {return}
                APIManager.manager.getData(endPoint: photograph.url) {(data: Data?) in
                    if let d = data {
                        if let image = UIImage(data: d) {
                            self.nasaImage.image = image
                        } else {
                            self.nasaImage.isHidden = true
                            self.button.isHidden = false
                        }

                    }
                    self.textLabel.text = photograph.explanation
                    
                    DispatchQueue.main.async {
                        self.view.reloadInputViews()
                    }
                }
            }
        }
    }
    
    func getDate(_ date: Date) -> String {
        
        let string = "\(date)"
            
        return string.components(separatedBy: " ")[0]
    }

    func getData (endPoint: String) {
        APIManager.manager.getData(endPoint: endPoint) { (data: Data?) in
            if let d = data {
                self.photo = Photo.parseData(data: d)
            }
        }
    }
  
}



