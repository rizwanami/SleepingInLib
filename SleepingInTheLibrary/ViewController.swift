//
//  ViewController.swift
//  SleepingInTheLibrary
//
//  Created by Jarrod Parkes on 11/3/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

import UIKit

// MARK: - ViewController: UIViewController

class ViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoTitleLabel: UILabel!
    @IBOutlet weak var grabImageButton: UIButton!
    
    // MARK: Actions
    
    @IBAction func grabNewImage(sender: AnyObject) {
        setUIEnabled(false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.enabled = enabled
        grabImageButton.enabled = enabled
        
        if enabled {
            grabImageButton.alpha = 1.0
        } else {
            grabImageButton.alpha = 0.5
        }
    }
    
    // MARK: Make Network Request
    
    private func getImageFromFlickr() {
        
        // TODO: Write the network code here!
        let methodParameter = [Constants.FlickrParameterKeys.Method: Constants.FlickrParameterValues.GalleryPhotosMethod,
                               Constants.FlickrParameterKeys.APIKey: Constants.FlickrParameterValues.APIKey,
                               Constants.FlickrParameterKeys.GalleryID : Constants.FlickrParameterValues.GalleryID,
                               Constants.FlickrParameterKeys.Format: Constants.FlickrParameterValues.ResponseFormat,
                               Constants.FlickrParameterKeys.Extras : Constants.FlickrParameterValues.MediumURL, Constants.FlickrParameterKeys.NoJSONCallback : Constants.FlickrParameterValues.DisableJSONCallback]
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(methodParameter)
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){(data, response, error) in
            if error == nil {
                print(data!)
            }
            
        }
        task.resume()
    }
    private func escapedParameters(parameters : [String : AnyObject])-> String {
        if parameters.isEmpty {
            return " "
        } else {
            var keyValuePairs = [String]()
            for (key, value) in parameters {
                let stringValue = "/(value)"
                let escapeValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                keyValuePairs.append(key + "=" + "\(escapeValue)")
                
            }
            return "?\(keyValuePairs.joinWithSeparator("&"))"
            
        }
        
        
    }
    
    
}