//
//  ViewController.swift
//  APOD
//
//  Created by Jason Gresh on 11/7/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var messageLabel: UILabel!

    let baseEndpoint = "https://api.nasa.gov/planetary/apod?api_key=GFIeaPoEgpWkTJrsKLINoa39nGmTs4TAoKU0Wiya"
    var apod: APOD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // make today's date the maximum
        self.datePicker.maximumDate = Date()
        getData(date: Date())
    }
    
    func getData(date: Date) {
        self.messageLabel.text = "Loading..."
        self.imageView.image = nil
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let endpointURL = baseEndpoint + "&date=\(dateFormatter.string(from: date))"
        APIRequestManager.manager.getData(endPoint: endpointURL) { (data: Data?) in
            if let validData = data {
                do {
                    if let apod = try APOD.apodFromData(data: validData) {
                        self.apod = apod
                        APIRequestManager.manager.getData(endPoint: apod.bestUrlString) { (data: Data?) in
                            if let validData = data {
                                DispatchQueue.main.async {
                                    if let image = UIImage(data: validData) {
                                        self.imageView.image = image
                                        self.messageLabel.text = apod.explanation
                                    }
                                }
                            }
                        }
                    }
                }
                catch APODError.unsupportedType {
                    DispatchQueue.main.async {
                        self.messageLabel.text = "Unsupported type"
                        self.imageView.image = nil
                    }
                }
                catch {
                    self.messageLabel.text = "Error"
                    print(error)
                }
            }
        }
    }
    
    @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
        self.messageLabel.isHidden = !self.messageLabel.isHidden
    }
    
    @IBAction func datePickerChanged(_ sender: UIDatePicker) {
        getData(date: sender.date)
    }
}

