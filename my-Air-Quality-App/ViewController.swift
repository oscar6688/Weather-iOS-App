//
//  ViewController.swift
//  my-Air-Quality-App
//
//  Created by Oscar Li on 3/31/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var bitmoji_imageView_wed: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickMeButtonAction(_ sender: Any) {
        makeApiCall()
    }
    
    func makeApiCall() {
        // get url
        let urlString = "https://api.airvisual.com/v2/city"
        var urlComponent = URLComponents(string: urlString)
        
        // var change down the code; let is one time
        guard var urlComponent else {
            print("Incorret URL") // do whatever you want to tell users that this is an incorrect url
            return
        }
        
        // add the params to the url
        urlComponent.queryItems = [
            URLQueryItem(name: "city", value: "Los Angeles"),
            URLQueryItem(name: "state", value: "California"),
            URLQueryItem(name: "country", value: "USA"),
            URLQueryItem(name: "key", value: "e509c7a7-8ddd-4ab6-962c-ab97309318fd"),
        ]
        // make api call
        // if there is url do this code
        guard let finalUrl = urlComponent.url else {
            print("Incorrect URL 2 ")
            return
        }
        let request = URLRequest(url:finalUrl)
        
        let task = URLSession.shared.dataTask(with:request) {[weak self]data, response, error in
            guard let data = data else {
                print("No Data from API call")
                return
                
            }
        
            print(String(data:data, encoding: .utf8)!)
            
            // clean up data
            
            let jsonObject = (try? JSONSerialization.jsonObject(with: data)) as? [String:Any]
            
            guard let jsonObject else { return }
            
            // data (json)
            let dataItem = jsonObject["data"] as? [String:Any]
            guard let dataItem else { return }
            
            // current (json)
            let current = dataItem["current"] as? [String:Any]
            guard let current else { return }
            
            // pollution (json)
            
            let pollution = current["pollution"] as? [String:Any]
            guard let pollution else { return }
            
            // aqius (String -> Int)
            // as? is not 100% to be dictionary
            let aqiusValue = pollution["aqius"] as? Int
            guard let aqiusValue else {
                print("Cannot find Aqius Value")
                return
            }
            // update images
            self?.updateBitmojiBasedOnAQIValue(value: aqiusValue)
            
        }
        
        task.resume()

        
    }
    
    func updateBitmojiBasedOnAQIValue(value: Int){
        var imageName = ""
        if (value <= 50){
            // good
            imageName = "air_happy"
        } else if (value <= 100){
            // moderate
            imageName = "air_meh"
        } else {
            imageName = "air_sad_2"
        }
        DispatchQueue.main.sync{
            bitmoji_imageView_wed.image = UIImage(named:imageName)
        }
    }
    
    // create a simple UI screen with our images (Done)
    // Write the scrip to tap on a button and perform an action (Done)
    // Make call to the API (Done)
    // Clean up the data (Done)
    // Show the right images based on the data (Done)
    // Think about edge cases


}

