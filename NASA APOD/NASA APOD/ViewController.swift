//
//  ViewController.swift
//  NASA APOD
//
//  Created by Harichandan Singh on 11/6/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: - Properties
    var apod: APOD?
    var apiEndpoint: String = "https://api.nasa.gov/planetary/apod?api_key=mK60KkoADmoovt75xt7q8doyv0uQjZx7GpcLrfQm"
    var dateParameterString: String {
        let date = apodDatePicker.date
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let formattedDateParameter = "&date=\(year)-\(month)-\(day)"
        return formattedDateParameter
    }
    var currentDate = Date()
    
    //MARK: - Outlets
    @IBOutlet weak var apodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var apodDatePicker: UIDatePicker!
    @IBOutlet weak var videoButton: UIButton!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.apodDatePicker.maximumDate = self.currentDate
        loadAPOD()
    }
    
    func loadAPOD() {
        let date = apiEndpoint + dateParameterString
        APIRequestManager.manager.getData(apiEndpoint: date) { (data: Data?) in
            if let apod = APOD.turnDataIntoAPOD(from: data!) {
                self.apod = apod
            }
            
            if self.apod?.mediaType == "image" {
                let imageString = self.apod?.urlString
                APIRequestManager.manager.getData(apiEndpoint: imageString!, callback: { (data: Data?) in
                    if let d = data {
                        DispatchQueue.main.async {
                            self.videoButton.isEnabled = false
                            self.titleLabel.text = self.apod?.title
                            self.apodImageView.image = UIImage(data: d)
                        }
                    }
                })
            }
            else {
                DispatchQueue.main.async {
                    self.videoButton.isEnabled = true
                    self.videoButton.setNeedsLayout()
                    self.titleLabel.text = self.apod?.title
                }
                
            }
        }
    }
    
    //MARK: - Actions
    @IBAction func apodDatePickerValueChanged(_ sender: UIDatePicker) {
        loadAPOD()
    }
    
    @IBAction func videoButtonTapped(_ sender: UIButton) {
        guard let urlString = apod?.urlString else { return }
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}


