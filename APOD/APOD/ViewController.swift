//
//  ViewController.swift
//  APOD
//
//  Created by Tong Lin on 11/6/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let apiKey = "eWfzIvejlfUgRroMIVYMEFAU5O1R5LT5k6OsZFLv"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var explanation: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    var apod = APOD(date: "", explanation: " ", title: "Welcome", imageURL: "")
    
    var date = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: datePicker.date)
        
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(){
        APIManager.manager.getAPOD(apiKey: apiKey, at: date) { (data: Data?) in
            if data != nil{
                DispatchQueue.main.async {
                    if let temp = APOD.apod(from: data!){
                        self.apod = temp
                    }
                }
            }
        }
        
        APIManager.manager.downloadImage(urlString: apod.imageURL) { (imageData: Data?) in
            if imageData != nil{
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: imageData!)
                }
            }else{
                print("image loading error")
            }
        }
        
        DispatchQueue.main.async {
            self.navigationItem.title = self.apod.title
            self.explanation.text = self.apod.explanation
        }
    }
    
    @IBAction func selectDate(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.string(from: sender.date)
        print(self.date)
        loadData()
    }
}

