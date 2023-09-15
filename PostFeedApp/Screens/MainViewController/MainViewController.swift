//
//  ViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit

class MainViewController: UIViewController, NetErrorViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkController = NetworkController()
    let expandableCellStorage = ExpandableCellStorage()
    var postData: [PostData] = []
    var currentSortType: SortType?

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
        networkController.fetchPosts { [weak self] result in
            do {
                let data = try result.get()
                self?.postData = data
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
        
        let postData = postData[indexPath.row]
        
        cell.config(with: postData)
        cell.cellIndexPath = indexPath
        cell.delegate = self
        
        expandableCellStorage.configureData(cell, for: indexPath)
        
        return cell
    }
}

extension MainViewController: PostFeedCellDelegate {
    func buttonPressed(indexPath: IndexPath) {
        expandableCellStorage.update(for: indexPath)
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
