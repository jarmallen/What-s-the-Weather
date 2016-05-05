//
//  ViewController.swift
//  What's the Weather
//
//  Created by Jared Allen on 11/24/15.
//  Copyright © 2015 Jared Allen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherForecastLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityTextField.delegate = self
    }

    @IBAction func getWeatherButton(sender: AnyObject) {
        
        var wasSuccessful = false
        
        let url = NSURL(string: "http://www.weather-forecast.com/locations/" + (cityTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "-")) + "/forecasts/latest")
        
        if let forecastUrl = url {
            
            let task = NSURLSession.sharedSession().dataTaskWithURL(forecastUrl) { (data, response, error) -> Void in
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    
                    let websiteArray = webContent!.componentsSeparatedByString("3 Day Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    
                    if websiteArray.count > 1 {
                        let weatherArray = websiteArray[1].componentsSeparatedByString("</span>")
                        
                        if weatherArray.count > 1 {
                            wasSuccessful = true
                            let forecastSummary = weatherArray[0].stringByReplacingOccurrencesOfString("&deg;", withString:"º ")
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.weatherForecastLabel.text = forecastSummary

                            })
                            
                            }
                        
                    
                        }
                        
                    if wasSuccessful == false {
                        self.weatherForecastLabel.text = "Forecast unavailable. Please try again."
                        
                    }
                }
            }
                
            task.resume()
                
        } else {
            self.weatherForecastLabel.text = "Forecast unavailable. Please try again"
                
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }


}

