//
//  DetailViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 01.09.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController {
    
    let networkController = NetworkController()
    var postId: Int = 0

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadNetworkData()
    }
    
    private func setupUI() {
        title = "Title"
        navigationController?.navigationBar.prefersLargeTitles = false
        
        imageView.kf.indicatorType = .activity
    }
    
    private func loadNetworkData() {
        networkController.fetchPostDetail(postId) { result in
            do {
                let data = try result.get()
                
                self.downloadImage(with: data.postImage) { image in
                    self.imageView.image = image
                }
                
                self.postNameLabel.text = data.title
                self.postTextLabel.text = data.text
                self.postLikesCountLabel.text = String(data.likesCount)
                
                let date = Date(timeIntervalSince1970: Double(data.timeshamp))
                let formatter = DateFormatter()
                formatter.dateFormat = "dd MMMM YYYY"
                let postDate = formatter.string(from: date)
                
                self.postDateLabel.text = postDate
            } catch {
                print(error)
            }
        }
    }
    
    private func downloadImage(with urlString: String, completion: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: urlString) else {
            return completion(nil)
        }
        
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
