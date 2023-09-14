//
//  NetworkImageController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 11.09.2023.
//

import UIKit

class DownloadImageController {
    func downloadImage(with urlString: String, for imageView: UIImageView, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return completion(nil)
        }
        
        DispatchQueue.main.async {
            imageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil) { result in
                switch result {
                case .success(let value):
                    completion(value.image)
                case .failure:
                    completion(nil)
                }
            }
        }
    }
}
