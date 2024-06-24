//
//  UIImageView.swift
//  UnsplashSearcher
//
//  Created by Rexhep Kelmendi on 19.5.24.
//

import Foundation
import UIKit

var imageCaches = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    func load(imgURL: String) {
        
        let width = 300
        let urlString = "\(imgURL)&w=\(width)"
        
        if let image = imageCaches.object(forKey: urlString as NSString) as? UIImage {
            self.image = image
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageCaches.setObject(image, forKey: urlString as NSString)
                        self?.image = image
                    }
                }
            }
        }
    }
}
