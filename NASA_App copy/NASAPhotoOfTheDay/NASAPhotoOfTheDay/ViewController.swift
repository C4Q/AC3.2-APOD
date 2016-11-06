//
//  ViewController.swift
//  NASAPhotoOfTheDay
//
//  Created by Amber Spadafora on 11/5/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
    
    var pics: nasaPicture = nasaPicture(date: "", summary: "", media: "", title: "", url: "")
    
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var pickOfTheDay: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var videoPlayer: UIWebView!
    
    var usersDatePick: String = ""
    
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        
        videoPlayer.isHidden = true
        datePicker.maximumDate = NSDate() as Date
        datePicker.backgroundColor = UIColor.gray
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let strDate = dateFormatter.string(from: datePicker.date)
        self.usersDatePick = strDate
        //self.dateLabel.text = strDate
        loadDatafromUsersChoice()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        videoPlayer.isHidden = true
        datePicker.backgroundColor = UIColor.lightGray
        
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        videoPlayer.backgroundColor = UIColor.clear
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
                self.dateLabel.text = self.pics.title
                if self.pics.media == "image" {
                    self.videoPlayer.isHidden = true
                    self.pickOfTheDay.isHidden = false
                    let url = URL(string: self.pics.url)
                    let data = try? Data(contentsOf: url!)
                    self.pickOfTheDay.image = UIImage(data: data!)
                } else if self.pics.media == "video" {
                    self.pickOfTheDay.isHidden = true
                    self.videoPlayer.isHidden = false
                    self.videoPlayer.backgroundColor = UIColor.clear
                    self.videoPlayer.allowsInlineMediaPlayback = true
                    let webUrl : URL = URL(string: "\(self.pics.url)")!
                    let webRequest : URLRequest = URLRequest(url: webUrl)
                    self.videoPlayer.loadRequest(webRequest)
                    
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
                    self.videoPlayer.isHidden = true
                    self.pickOfTheDay.isHidden = false
                    let url = URL(string: self.pics.url)
                    let data = try? Data(contentsOf: url!)
                    self.pickOfTheDay.image = UIImage(data: data!)
                } else if self.pics.media == "video" {
                    self.pickOfTheDay.isHidden = true
                    self.videoPlayer.isHidden = false
                    self.videoPlayer.allowsInlineMediaPlayback = true
                    let webUrl : URL = URL(string: "\(self.pics.url)")!
                    let webRequest : URLRequest = URLRequest(url: webUrl)
                    self.videoPlayer.loadRequest(webRequest)
                    
                }
                self.summaryLabel.text = self.pics.summary
            }
        }
    }
    
    
    
}

