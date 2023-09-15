//
//  DetailViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 01.09.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController, NetErrorViewControllerDelegate {
    
    let networkController = NetworkController()
    let downloadImageController = DownloadImageController()
    var postId: Int = 0

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadNetworkData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupUI() {
        imageView.kf.indicatorType = .activity
    }
    
    func loadNetworkData() {
        networkController.fetchPostDetail(postId) { [weak self] result in
            do {
                let data = try result.get()
                self?.configureUI(data.title, data.text, data.likesCount, data.timeshamp, data.postImage)
            } catch {
                print(error.localizedDescription)
                self?.showErrorScreen(error.localizedDescription)
            }
        }
    }
    
    func showErrorScreen(_ error: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "NetErrorScreen", bundle: nil)
            guard let netErrorsVC = storyboard.instantiateViewController(withIdentifier: "NetErrorScreen") as? NetErrorViewController else {
                return
            }
            
            netErrorsVC.delegate = self
            self.navigationController?.pushViewController(netErrorsVC, animated: false)
        }
    }
    
    private func configureUI(_ postName: String, _ postText: String, _ postLikesCount: Int, _ postDate: Int, _ postImage: String) {
        DispatchQueue.main.async {
            let date = Date(timeIntervalSince1970: Double(postDate))
            
            self.postNameLabel.text = postName
            self.postTextView.text = postText
            self.postLikesCountLabel.text = String(postLikesCount)
            self.postDateLabel.text = date.fullDateDisplay
        }
        
        loadImage(image: postImage)
    }
    
    private func loadImage(image: String) {
        downloadImageController.downloadImage(with: image, for: imageView) { [weak self] image in
            self?.imageView.image = image
        }
    }
}
