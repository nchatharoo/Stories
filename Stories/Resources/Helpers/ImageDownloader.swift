//
//  ImageDownloader.swift
//  Stories
//
//  Created by Nadheer on 27/06/2022.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadImageFrom(link: URL) {
                
        URLSession.shared.dataTask(with: link, completionHandler: { (data, _, _) -> Void in
            
            DispatchQueue.main.async { [weak self] in
                
                if let imageData = data,
                   let downloadedImage = UIImage(data: imageData) {
                    
                    self?.image = downloadedImage
                    
                    DispatchQueue.global(qos: .background).async {
                        ImageCache.shared.setObject(downloadedImage, forKey: link.absoluteString as AnyObject)
                    }
                }
            }
        }).resume()
    }
}


fileprivate let ONE_HUNDRED_MEGABYTES = 1024 * 1024 * 100

class ImageCache: NSCache<AnyObject, AnyObject> {
    static let shared = ImageCache()
    private override init() {
        super.init()
        self.setMaximumLimit()
    }
}

extension ImageCache {
    func setMaximumLimit(size: Int = ONE_HUNDRED_MEGABYTES) {
        totalCostLimit = size
    }
}
