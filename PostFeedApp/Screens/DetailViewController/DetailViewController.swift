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
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var heartImageBottomConstraint: NSLayoutConstraint!
    
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
        setupTapGesture()
        imageView.kf.indicatorType = .activity
    }
    
    func loadNetworkData() {
        networkController.fetchPostDetail(postId) { [weak self] result in
            do {
                let data = try result.get()
                self?.configureUI(data.title, data.text, data.likesCount, data.timeshamp, data.postImage)
            } catch {
                self?.showErrorScreen(error.localizedDescription)
            }
        }
    }
    
    func showErrorScreen(_ error: String) {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: Constants.netErrorStoryboardName, bundle: nil)
            guard let netErrorsVC = storyboard.instantiateViewController(withIdentifier: Constants.netErrorViewControllerId) as? NetErrorViewController else {
                return
            }
            
            netErrorsVC.delegate = self
            netErrorsVC.descriptionError = error
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
    
    private func setupTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        
        heartImage.addGestureRecognizer(tap)
        heartImage.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let viewTag = sender?.view?.tag else { return }
        setAnimation(viewTag: viewTag)
    }
    
    private func setAnimation(viewTag: Int) {
        if viewTag == Constants.postFeedDetailHeartViewTag {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 5.0, options: [.autoreverse]) {
                self.heartImageBottomConstraint.constant = 15
                self.heartImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.view.layoutIfNeeded()
            } completion: { _ in
                self.heartImageBottomConstraint.constant = 10
                self.heartImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            let currentLikesCount = Int(postLikesCountLabel.text ?? "0")
            
            if var currentLikesCount {
                currentLikesCount += 1
                postLikesCountLabel.text = String(currentLikesCount)
            }
        }
    }
}
