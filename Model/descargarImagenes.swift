//
//  descargarImagenes.swift
//  peliculasAPI
//
//  Created by user223791 on 9/13/22.
//

import Foundation
import UIKit

let cache = NSCache<NSString, UIImage>()
let utilityQueue = DispatchQueue.global(qos: .utility)

func descargarImagenes(pathImage: String, imageView : UIImageView){
    
    let name = pathImage
    let imageName = "https://image.tmdb.org/t/p/original" + name
    let cacheString = NSString(string: imageName)
            
    if let cacheImage = cache.object(forKey: cacheString) {
        imageView.image = cacheImage
    } else {
        loadImage(from: URL(string: imageName)) { (image) in
            imageView.image = image
            //self.cache.setObject(image, forKey: cacheString)!
        }
    }
}

func loadImage(from url: URL?, completion: @escaping (UIImage?) -> ()) {
        utilityQueue.async {
            guard let data = try? Data(contentsOf: url!) else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
