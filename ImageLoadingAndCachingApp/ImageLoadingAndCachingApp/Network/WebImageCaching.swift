//
//  WebImageCaching.swift
//  ImageLoadingAndCachingApp
//
//  Created by Devesh Pandey on 21/04/24.
//

import Foundation
import UIKit

class LazyImageView : UIImageView {
   private let imageCache = NSCache<AnyObject,UIImage>()
    func loadImage(fromURL imageURL : URL ,placeholderImage : String)
    {
        self.image = UIImage(named: placeholderImage)
        if let cachedImage = self.imageCache.object(forKey: imageURL as AnyObject){
            self.image = cachedImage
            return
        }
        
        DispatchQueue.global().async {
            [weak self] in
            if let imageData = try? Data(contentsOf: imageURL)
            {
                if let image = UIImage(data: imageData)
                {
                    DispatchQueue.main.async {
                        self!.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        self?.image = image
                    }
                }
            }
        }
    }
    
    public func loadImage2(fromURL url : String, placeholderImage : String){
        self.image = UIImage(named: placeholderImage)
        guard let imageURL = URL(string: url) else{
            return
        }
        let cache = URLCache.shared
        let request = URLRequest(url: imageURL)
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = cache.cachedResponse(for: request)?.data, let image = UIImage(data:data){
                DispatchQueue.main.async{
                    self.transition(toImage: image)
                }
            }else{
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let data = data , let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300 , let image = UIImage(data : data) {
                        let cachedData = CachedURLResponse(response: response , data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        DispatchQueue.main.async {
                            self.transition(toImage: image)
                        }
                        
                    }
                }.resume()
            }
        }
    }
    public func transition(toImage image : UIImage?){
        UIView.transition(with: self, duration: 0.3, options: [.transitionCrossDissolve],animations: {self.image = image},completion: nil)
    }
}
