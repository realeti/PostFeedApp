//
//  DetailViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 01.09.2023.
//

import UIKit
import Kingfisher

class DetailViewController: UIViewController, NetErrorViewControllerDelegate {
    
    let downloadImageController = DownloadImageController()
    var postId: Int = 0

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var detailPostView: UIView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var heartImageBottomConstraint: NSLayoutConstraint!
    
    var isLiked = false
    
    private lazy var fallbackController: PostDetailFallbackController = {
        PostDetailFallbackController(
            mainSource: NetworkController(),
            reserveSource: CoreDataController.shared)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadNetworkData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        
        view.backgroundColor = UIColor(named: Constants.backgroundColor)
        detailPostView.backgroundColor = UIColor(named: Constants.backgroundColor)
        postTextView.backgroundColor = UIColor(named: Constants.backgroundColor)
        
        postTextView.textColor = UIColor(named: Constants.postTextColor)
        heartImage.tintColor = isLiked ? UIColor(named: Constants.heartLikeColor) : UIColor(named: Constants.postRatingColor)
        postLikesCountLabel.textColor = UIColor(named: Constants.postRatingColor)
        postDateLabel.textColor = UIColor(named: Constants.postRatingColor)
    }
    
    private func setupUI() {
        setupTapGesture()
        imageView.kf.indicatorType = .activity
    }
    
    func loadNetworkData() {
        fallbackController.fetchPostDetail(postId) { [weak self] result in
            do {
                let post = try result.get()
                self?.configureUI(
                    post.title,
                    post.text,
                    post.likesCount,
                    post.timeshamp,
                    post.postImage
                )
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
        updateLikes(viewTag: viewTag)
    }
    
    func updateLikes(viewTag: Int) {
        if viewTag == Constants.postFeedHeartViewTag {
            let currentLikesCount = Int(postLikesCountLabel.text ?? "0") ?? 0
            
            if isLiked {
                removeLike(likesCount: currentLikesCount - 1)
            } else {
                //setLike(likesCount: currentLikesCount + 1)
            }
        }
    }
    
    /*func setLike(likesCount: Int) {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 6.0) {
            self.heartImageCenterConstraint.constant = -5
            self.heartImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.heartImage.tintColor = UIColor(named: Constants.heartLikeColor)
            self.layoutIfNeeded()
        } completion: { _ in
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 6.0) {
                self.heartImageCenterConstraint.constant = 0
                self.heartImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.layoutIfNeeded()
            }
        }
        postLikesCountLabel.text = String(likesCount)
        isLiked = true
    }*/
    
    func removeLike(likesCount: Int) {
        heartImage.tintColor = UIColor(named: Constants.postRatingColor)
        postLikesCountLabel.text = String(likesCount)
        isLiked = false
    }
}
