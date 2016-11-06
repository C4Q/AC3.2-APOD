//
//  ViewController.swift
//  NASA_APOD
//
//  Created by Ana Ma on 11/5/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class NASA_APODViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var playButton: UIButton!
    
    var dateString : String {
        let date = String(describing: datePicker.date).components(separatedBy: " ")
        return date[0]
    }
    
    var selectedURLString : String {
        return "https://api.nasa.gov/planetary/apod?api_key=VeliJSoMU1ooTimlXuxt57TyLhpJLB7Ksdgqm1ZV" + "&date=" + dateString + "&hd=false"
    }
    
    var apod = Apod(copyright: "John Hayes", date: "2016-11-02", explanation: "The first hint of what will become of our Sun was discovered inadvertently in 1764. At that time, Charles Messier was compiling a list of diffuse objects not to be confused with comets. The 27th object on Messier's list, now known as M27 or the Dumbbell Nebula, is a planetary nebula, the type of nebula our Sun will produce when nuclear fusion stops in its core. M27 is one of the brightest planetary nebulae on the sky, and can be seen toward the constellation of the Fox (Vulpecula) with binoculars. It takes light about 1000 years to reach us from M27,  shown above in colors emitted by hydrogen and oxygen. Understanding the physics and significance of M27 was well beyond 18th century science. Even today, many things remain mysterious about bipolar planetary nebula like M27, including the physical mechanism that expels a low-mass star's gaseous outer-envelope, leaving an X-ray hot white dwarf.", hdurl: "http://apod.nasa.gov/apod/image/1611/M27_Hayes_2623.jpg", media_type: "image", service_version: "v1", title: "M27: The Dumbbell Nebula", url: "http://apod.nasa.gov/apod/image/1611/M27_Hayes_960.jpg")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadInfo()
    }
    
    func loadInfo () {
        //let printString = urlString + "&date=" + dateString + "&hd=false"
        APIManager.manager.getData(from: selectedURLString){(data: Data?) in
            guard let validApodData = data else {return}
            if let apod = Apod.getAPOD(from: validApodData){
                self.apod = apod
                switch apod.media_type {
                case "image":
                    if let urlStringImage = apod.url{
                        APIManager.manager.getData(from: urlStringImage , complete: { (data: Data?) in
                            guard let validImagedata = data else {return}
                            DispatchQueue.main.async {
                                self.playButton.isHidden = true
                                self.imageView.isHidden = false
                                self.imageView.image = UIImage(data: validImagedata)
                                self.titleLabel.text = apod.title
                            }
                        })
                    }
                case "video":
                    DispatchQueue.main.async {
                        self.playButton.isHidden = false
                        self.imageView.isHidden = true
                        self.titleLabel.text = apod.title
                    }
                default:
                    break
                }
                dump(apod)
                DispatchQueue.main.async {
                    self.view.reloadInputViews() //54sec
                    //self.imageView.reloadInputViews() //1.15min
                    //self.titleLabel.reloadInputViews()
                }
            }
            //dump(validData)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dateSelected(_ sender: UIDatePicker) {
        loadInfo()
    }
    @IBAction func playButtonTapped(_ sender: UIButton) {
        guard let urlStringVideo = self.apod.url else {return}
        guard let url = URL(string: urlStringVideo) else {return}
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}

