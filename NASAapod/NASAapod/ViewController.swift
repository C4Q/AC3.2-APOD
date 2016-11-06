//
//  ViewController.swift
//  NASAapod
//
//  Created by Ilmira Estil on 11/6/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var allApods = [Apod]()
    override func viewDidLoad() {
        super.viewDidLoad()
        APIRequestManager.manager.getData(endPoint: Apod.endpoint) { (data: Data?) in
            if data != nil {
                if let validData = data,
                    let validApod = Apod.getApodData(from: validData) {
                    self.allApods = validApod
                    DispatchQueue.main.async {
                        self.tableView?.reloadData()
                        print("Apod array: \(self.allApods)")
                    }
                }
            }
        }
    }
    
    
    
}

