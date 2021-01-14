//
//  ImageLoader.swift
//  Product List
//
//  Created by Mitchell Sweet on 1/4/18.
//  Copyright © 2018 Mitchell Sweet. All rights reserved.
//

import Foundation
import UIKit

class ImageLoader {
    var cachedImages = [URL: UIImage]() // Create dictionary to cache images after downloaded.
    
    /// Loads image from url and passes image through completion handler.
    func loadImage(url: URL, completionHandler: @escaping (UIImage?, Error?) -> Void) {
        
        // If the image has been cached, pass image through completion handler and stop function.
        if let cached = cachedImages[url] {
            completionHandler(cached, nil)
            return
        }
        
        
        // Download images on global queue.
        DispatchQueue.global(qos: .userInitiated).async {
            // Create URL session data task to retrieve image from URL.
            URLSession.shared.dataTask(with: url) { data, response, error in
                // Handle error if one is returned.
                if let error = error {
                    completionHandler(nil, error)
                    return
                }
                // Check to see if image exists.
                guard let data = data else { return }
                // Create image constant
                let image = UIImage(data: data)
                // Pass image on main queue.
                DispatchQueue.main.async {
                    self.cachedImages[url] = image // Cache image.
                    completionHandler(image, nil) // Pass image through completion handler.
                }
            }.resume()
        }
    }
}

