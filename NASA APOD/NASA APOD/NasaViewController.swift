//
//  ViewController.swift
//  NASA APOD
//
//  Created by Annie Tung on 11/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class NasaViewController: UIViewController, UIPickerViewDelegate {
    
    var nasa: Nasa?
    var baseApiPoint = "https://api.nasa.gov/planetary/apod?api_key=HHy5z1GsmcW1e7ODO6YLHFQxg2xuMCkzkOC23B67"
    var customDate = "&date=YYYY-MM-DD"
    
    // MARK: - Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.label.text = nasa.description
        self.datePicker.maximumDate = Date()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGuesture))
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(tapGesture)
     }
    
    var isVideo = false
    var videoURL = ""
    func handleTapGuesture() {
        if isVideo {
            if let url = URL(string: videoURL) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func valueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let stringDate = dateFormatter.string(from: sender.date)
        loadData(date: "&date=\(stringDate)")
    }
    
    // MARK: - Methods
    func loadData(date: String) {
        APIRequestManager.manager.getData(APIEndPoint: baseApiPoint + date) { (data: Data?) in
            guard let validData = data else { return }
            if let validNasa = Nasa.generateNasa(data: validData) {
                DispatchQueue.main.async {
                    self.nasa = validNasa
                    dump(validNasa)
                    
                    if let validatedNASA = self.nasa {
                        if validatedNASA.mediaType == "image" {
                            self.isVideo = false
                            APIRequestManager.manager.getData(APIEndPoint: validatedNASA.url, callback: { (data: Data?) in
                                guard let validData = data else { return }
                                DispatchQueue.main.async {
                                    self.image.image = UIImage(data: validData)
//                                    self.image.layoutIfNeeded()
                                }
                            })
                        } else {
                            self.isVideo = true
                            self.videoURL = validatedNASA.url
                        }
                    }
                }
            }
        }
    }
}





