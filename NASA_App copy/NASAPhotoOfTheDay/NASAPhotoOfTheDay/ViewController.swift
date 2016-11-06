//
//  ViewController.swift
//  NASAPhotoOfTheDay
//
//  Created by Amber Spadafora on 11/5/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pics: nasaPicture = nasaPicture(date: "", summary: "", media: "", title: "", url: "")
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pickOfTheDay: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    
    var usersDatePick: String = ""
    

    
    
    
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
        datePicker.maximumDate = NSDate() as Date
        datePicker.backgroundColor = UIColor.white
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        print(strDate)
        self.usersDatePick = strDate
        //self.dateLabel.text = strDate
        loadDatafromUsersChoice()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print(pics)
        datePicker.backgroundColor = UIColor.white
        
    }
    
    
    
    func loadData() {
        APIManager.manager.getData { (data) in
            
            guard let unwrappedData = data else {
                print("error occurred")
                return
            }
            
            self.pics = nasaPicture.createPic(from: unwrappedData)!
            print("api worked")
            
            
            DispatchQueue.main.async {
                self.dateLabel.reloadInputViews()
                self.dateLabel.text = "Caption: \(self.pics.title)"
                if self.pics.media == "image" {
                    let url = URL(string: self.pics.url)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    self.pickOfTheDay.image = UIImage(data: data!)
                    
                }
                self.summaryLabel.text = self.pics.summary
            }
        }
    }
    
    func loadDatafromUsersChoice() {
        APIManager.manager.getDataforChosenDate(date: usersDatePick) { (data) in
            
            guard let unwrappedData = data else {
                print("error occurred")
                return
            }
            
            self.pics = nasaPicture.createPic(from: unwrappedData)!
            print("api worked")
            
            
            DispatchQueue.main.async {
                self.dateLabel.reloadInputViews()
                self.dateLabel.text = "Caption: \(self.pics.title)"
                if self.pics.media == "image" {
                    let url = URL(string: self.pics.url)
                    let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                    self.pickOfTheDay.image = UIImage(data: data!)
                    
                }
                self.summaryLabel.text = self.pics.summary
            }
        }
    }
    
    
    
}

