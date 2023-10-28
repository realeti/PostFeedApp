//
//  MainViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit

class MainViewController: UIViewController, NetErrorViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let expandableCellStorage = ExpandableCellStorage()
    var postData: [PostFeed] = []
    var currentSortType: SortType?
    
    private lazy var fallbackController: PostFallbackController = {
        PostFallbackController(
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
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        title = Constants.mainTitle
        
        let cellIdentifier = Constants.customCellId
        let customCellTypeNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(customCellTypeNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func loadNetworkData() {
        fallbackController.fetchPosts { [weak self] result in
            do {
                let posts = try result.get()
                self?.postData = posts
            } catch {
                self?.postData = []
                self?.showErrorScreen(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let filterVC = segue.destination as? FilterViewController else { return }
        filterVC.delegate = self
        
        if let currentSortType {
            filterVC.currentSortType = currentSortType
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: Constants.detailStroboardName, bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailViewControllerId) as? DetailViewController else {
            return
        }
        
        detailVC.postId = postData[indexPath.row].postId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.customCellId) as? PostFeedCell else {
            return UITableViewCell()
        }
        
        let currentPost = postData[indexPath.row]
        let postId = currentPost.postId
        
        cell.config(with: currentPost)
        cell.cellIndexPath = indexPath
        cell.postId = postId
        cell.delegate = self
        
        let viewWidth = self.view.frame.size.width - 32 // leading & trailling it's 16 + 16
        expandableCellStorage.configureData(cell, for: postId, viewWidth, postData.count)
        
        return cell
    }
}

extension MainViewController: PostFeedCellDelegate {
    func buttonPressed(indexPath: IndexPath, postId: Int) {
        expandableCellStorage.update(for: postId)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension MainViewController: FilterViewControllerDelegate {
    func sortPostData(sortType: SortType) {
        switch sortType {
        case .newest:
            postData.sort { $0.timeshamp > $1.timeshamp }
        case .rating:
            postData.sort { $0.likesCount > $1.likesCount }
        }
        
        currentSortType = sortType
        
        tableView.reloadData()
        presentedViewController?.dismiss(animated: true)
    }
}
