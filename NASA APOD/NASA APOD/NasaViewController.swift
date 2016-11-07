//
//  ViewController.swift
//  NASA APOD
//
//  Created by Annie Tung on 11/6/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class NasaViewController: UIViewController {
    
    var nasa: [Nasa]?
    var apiPoint = "https://api.nasa.gov/planetary/apod?api_key=HHy5z1GsmcW1e7ODO6YLHFQxg2xuMCkzkOC23B67"
    var customDate = "&date=YYYY-MM-DD"
    
    
// MARK: - Outlets
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    
// MARK: - Actions
    @IBAction func valueChanged(_ sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        var StringDate = dateFormatter.string(from: sender.date)
        dateFormatter.dateFormat = "YYYY-MM-DD"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.label.text = nasa.description
        loadData()
    }


// MARK: - Methods
    func loadData() {
        APIRequestManager.manager.getData(APIEndPoint: apiPoint) { (data: Data?) in
            guard let validData = data else { return }
            if let validNasa = Nasa.generateNasa(data: validData) {
                self.nasa = validNasa
                dump(validNasa)
            }
            if self.nasa?.mediaType == "image" {
                APIRequestManager.manager.getData(APIEndPoint: apiPoint) {(data: Data?) in
                    guard let validData = data else { return }
                    if let validImage = UIImage(validData) {
                        DispatchQueue.main.async {
                            self.image = validImage
                        }
                    }
                }
            }
            else {
                return
            }
        }
    }

}
