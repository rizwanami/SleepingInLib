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
        setUIEnabled(enabled: false)
        getImageFromFlickr()
    }
    
    // MARK: Configure UI
    
    private func setUIEnabled(enabled: Bool) {
        photoTitleLabel.isEnabled = enabled
        grabImageButton.isEnabled = enabled
        
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
        let urlString = Constants.Flickr.APIBaseURL + escapedParameters(parameters: methodParameter as [String : AnyObject])
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(url: url as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest){(data, response, error) in
            func displayError(error: String) {
                print(error)
                print("url at the time of error is \(url)")
                
            }
            guard (error == nil) else {
                displayError(error: "KKKKK")
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode , statusCode <= 200 && statusCode >= 299 else {
                displayError(error: "DDDDDD")
                return
            }
            
            
                guard let data = data else{
            displayError(error: "NNNNN")
                    return
            }
                let parsedResult : Any
            
                    do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    } catch {
                        displayError(error: "NNNN")
                        return
                        
                    }
                    
                    guard let dictotionaryObject = parsedResult[Constants.FlickrResponseKeys.Photos] as? [String : AnyObject],
             let photoArray = dictotionaryObject[Constants.FlickrResponseKeys.Photo] as? [[String: AnyObject]] else{
                displayError(error: "KKKKK")
                return
            }
                        let randomPhotoIndex = Int(arc4random_uniform(UInt32(photoArray.count)))
                        let photoDictionary = photoArray[randomPhotoIndex] as? [String: AnyObject]
                        let randomimagePhoto = Int(arc4random_uniform(UInt32(photoArray.count)))
                        let photoDictionay = photoArray[randomPhotoIndex] as? [String : AnyObject]
                        guard let imageURlString = photoDictionary![Constants.FlickrResponseKeys.MediumURL] as? String,
           
                            let imageTitle = photoDictionary![Constants.FlickrResponseKeys.Title] as? String else {
                                displayError(error: "SSSS")
                                return
            }
                             let imageUrl = NSURL(string: imageURlString)
             guard let imageData = NSData(contentsOf: imageUrl! as URL)else {
                displayError(error: "LLLL")
                return
            }
                                performUIUpdatesOnMain() {
                                self.photoImageView.image = UIImage(data: imageData as Data)
                                self.photoTitleLabel.text = imageTitle
                                self.setUIEnabled(enabled: true)
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
                let stringValue = "\(value)"
                let escapeValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
                keyValuePairs.append(key + "=" + "\(escapeValue!)")
                
            }
            return "?\(keyValuePairs.joined(separator: "&"))"
            
        }
        
        
    }
}

    
