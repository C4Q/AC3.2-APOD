//
//  ViewController.swift
//  NASAapod
//
//  Created by Ilmira Estil on 11/6/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var apods: Apod?
    @IBOutlet weak var apodImage: UIImageView!
    @IBOutlet weak var apodLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadApod()
        viewLoadDefault()
        
    }
    
    
    @IBAction func changedDataPicker(_ sender: UIDatePicker) {
        //date format
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: datePicker.date)
        
        APIRequestManager.manager.getData(endPoint: Apod.endpoint, date: dateString) { (data: Data?) in
            if  let validData = data,
                let validApod = Apod.getApodData(from: validData) {
                self.apods = validApod
                DispatchQueue.main.async {
                    self.viewDidLoad()
                }
            }
        }
        
    }
    
    //MARK - Utility Funcs
    
    func loadApod() {
        guard let imageString = apods?.regURL else {return}
        if apods?.mediaType == "image" {
            APIRequestManager.manager.getData(endPoint: imageString, date: "") { (data: Data?) in
                if data != nil {
                    if let validData = data,
                        let validImage = UIImage(data: validData) {
                        DispatchQueue.main.async {
                            self.apodImage.image = validImage
                            self.apodLabel.text = self.apods?.title
                        }
                    }
                }
            }
        }
    }
    
    //MARK - Styling
    
    func viewLoadDefault() {
        datePicker.setValue(UIColor.gray, forKeyPath: "textColor")
        self.apodLabel.text = ""
    }



}

