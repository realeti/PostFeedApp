//
//  PostFeedCell.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit
import Kingfisher

class PostFeedCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var likesCountView: UIView!
    @IBOutlet weak var commentsCountView: UIView!
    @IBOutlet weak var postNameLabel: UILabel!
    @IBOutlet weak var postAuthorLabel: UILabel!
    @IBOutlet weak var postAuthorImage: UIImageView!
    @IBOutlet weak var postPreviewTextLabel: UILabel!
    @IBOutlet weak var postLikesCountLabel: UILabel!
    @IBOutlet weak var postCommentsCountLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var expandedButton: UIButton!
    @IBOutlet weak var heartImage: UIImageView!
    @IBOutlet weak var commentsImage: UIImageView!
    //@IBOutlet weak var heartImage: UIImageView!
    //@IBOutlet weak var heartImageBottomConstraint: NSLayoutConstraint!
    
    weak var delegate: PostFeedCellDelegate?
    let downloadImageController = DownloadImageController()
    var cellIndexPath: IndexPath?
    var postId: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupUI()
    }
    
    private func setupUI() {
        self.backgroundColor = .clear
        cellView.backgroundColor = UIColor(red: 68.0/255.0, green: 69.0/255.0, blue: 73.0/255.0, alpha: 1.0)
        cellView.layer.cornerRadius = 10
        likesCountView.backgroundColor = UIColor(red: 29.0/255.0, green: 32.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        likesCountView.layer.cornerRadius = 7
        commentsCountView.backgroundColor = UIColor(red: 29.0/255.0, green: 32.0/255.0, blue: 40.0/255.0, alpha: 1.0)
        commentsCountView.layer.cornerRadius = 7
        heartImage.tintColor = UIColor(red: 176.0/255.0, green: 177.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        commentsImage.tintColor = UIColor(red: 176.0/255.0, green: 177.0/255.0, blue: 179.0/255.0, alpha: 1.0)
        
        postAuthorImage.kf.indicatorType = .activity
        postAuthorImage.layer.cornerRadius = postAuthorImage.frame.width / 2
        
        postAuthorLabel.textColor = UIColor(red: 147.0/255.0, green: 145.0/255.0, blue: 157.0/255.0, alpha: 1.0)
        postDateLabel.textColor = UIColor(red: 147.0/255.0, green: 145.0/255.0, blue: 157.0/255.0, alpha: 1.0)
        
        setupTapGesture()
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if let cellIndexPath, let postId {
            delegate?.buttonPressed(indexPath: cellIndexPath, postId: postId)
        }
    }
    
    func config(with postData: PostFeed) {
        let postName = postData.title
        let postAuthor = postData.authorName
        let postAuthorAvatar = postData.authorAvatar
        let postPreviewText = postData.previewText
        let postLikesCount = postData.likesCount
        let postCommentsCount = postData.commentsCount
        let postDate = postData.timeshamp
        
        configure(postName, postAuthor, postAuthorAvatar, postPreviewText, postLikesCount, postCommentsCount, postDate)
    }
    
    func configure(_ postName: String, _ postAuthor: String, _ postAuthorAvatar: String, _ postPreviewText: String, _ postLikesCount: Int, _ postCommentsCount: Int, _ postDate: Int) {
        let date = Date(timeIntervalSince1970: Double(postDate))
        
        postNameLabel.text = postName
        postAuthorLabel.text = postAuthor
        postPreviewTextLabel.text = postPreviewText
        postLikesCountLabel.text = String(postLikesCount)
        postCommentsCountLabel.text = String(postCommentsCount)
        postDateLabel.text = date.fullDateDisplay
        loadImage(image: postAuthorAvatar)
    }
    
    private func setupTapGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        tap.numberOfTapsRequired = 1
        
        //heartImage.addGestureRecognizer(tap)
        //heartImage.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let viewTag = sender?.view?.tag else { return }
        setAnimation(viewTag: viewTag)
    }
    
    private func setAnimation(viewTag: Int) {
        if viewTag == Constants.postFeedHeartViewTag {
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 4.0, initialSpringVelocity: 6.0, options: [.autoreverse]) {
                //self.heartImageBottomConstraint.constant = 15
                //self.heartImage.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.layoutIfNeeded()
            } completion: { _ in
                //self.heartImageBottomConstraint.constant = 10
                //self.heartImage.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
            
            let currentLikesCount = Int(postLikesCountLabel.text ?? "0")
            
            if var currentLikesCount {
                currentLikesCount += 1
                postLikesCountLabel.text = String(currentLikesCount)
            }
        }
    }
    
    private func loadImage(image: String) {
        downloadImageController.downloadImage(with: image, for: postAuthorImage) { [weak self] image in
            self?.postAuthorImage.image = image
        }
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        
        return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
    }
}
