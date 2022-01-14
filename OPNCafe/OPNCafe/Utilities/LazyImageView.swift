//
//  LazyLoadImageView.swift
//  OPNCafe
//
//  Created by Detchat Boonpragob on 12/1/2565 BE.
//

import Foundation
import UIKit



class LazyImageView: UIImageView {
    typealias LazyCallBack = (_ image:UIImage?,_ urlString:String?,_ error:Error?) -> Void
    
    var currentURLString:String?
    var currentFileID:String?
    
    func load(urlString:String,defaultImage:UIImage? = nil)  {
        
        if self.currentURLString != urlString {
            self.image = defaultImage
        }
        
        self.currentURLString = urlString
        
        loadAsync(urlString: urlString) { (loadedImage,loadedURLString, error) in
            if loadedURLString == self.currentURLString,let image = loadedImage {
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
    
    private func loadAsync(urlString:String, isAsync:Bool = true, complement:@escaping LazyCallBack)  {
        if let url = URL(string: urlString)
        {
            if isAsync {
                let request = URLRequest.init(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 20000)
                let session = URLSession.shared;
                let task = session.dataTask(with: request) { (data, response, error) in
                    if let imageData = data, let image = UIImage.init(data: imageData, scale: 1.0) {
                        complement(image,urlString,nil)
                    }
                    else
                    {
                        complement(nil,urlString,error)
                    }
                }
                task.resume()
            }
            else
            {
                do {
                    let imageData = try Data.init(contentsOf: url)
                    if let image = UIImage(data: imageData) {
                        complement(image,urlString,nil)
                    }
                    else
                    {
                        complement(nil,urlString,NSError(domain:"", code:901, userInfo:[ NSLocalizedDescriptionKey: "Cannot load image"]))
                    }
                }
                catch {
                    complement(nil,urlString,NSError(domain:"", code:901, userInfo:[ NSLocalizedDescriptionKey: "Cannot load image"]))
                }
            }
            
        }
        else
        {
            complement(nil,urlString,NSError(domain:"", code:901, userInfo:[ NSLocalizedDescriptionKey: "Cannot load image"]))
        }
        
    }
    
    
}



