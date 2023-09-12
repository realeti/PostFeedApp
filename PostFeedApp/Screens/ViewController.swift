//
//  ViewController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let networkController = NetworkController()
    var postData: [PostData] = []
    var expandedCells: IndexSet = []
    var longCells: IndexSet = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadNetworkData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        title = Constants.mainTitle
        
        let cellIdentifier = String(describing: CustomCell.self)
        let customCellTypeNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(customCellTypeNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func loadNetworkData() {
        networkController.fetchPosts { [unowned self] result in
            do {
                let data = try result.get()
                self.postData = data
            } catch {
                self.postData = []
                print(error)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let filterVC = segue.destination as? FilterViewController else { return }
        filterVC.sortType = { [unowned self] sort in
            guard let currentSortType = SortType(rawValue: sort) else { return }
            
            switch currentSortType {
            case .newest:
                self.postData.sort { $0.timeshamp > $1.timeshamp }
            case .rating:
                self.postData.sort { $0.likesCount > $1.likesCount }
            }
            
            self.tableView.reloadData()
            self.presentedViewController?.dismiss(animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        
        guard let detailVC = storyboard.instantiateViewController(withIdentifier: Constants.detailViewControllerId) as? DetailViewController else {
            return
        }
        
        detailVC.postId = postData[indexPath.row].postId
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.customCellId) as? CustomCell else {
            return UITableViewCell()
        }
        
        let postName = postData[indexPath.row].title
        let postPreviewText = postData[indexPath.row].previewText
        let postLikesCount = postData[indexPath.row].likesCount
        let postDate = postData[indexPath.row].timeshamp
        
        cell.configure(postName, postPreviewText, postLikesCount, postDate)
        
        if cell.postPreviewTextLabel.maxNumberOfLines <= 2 && !longCells.contains(indexPath.row) {
            cell.expandedButton.isHidden = true
        } else {
            cell.expandedButton.isHidden = false
            longCells.insert(indexPath.row)
            
            if expandedCells.contains(indexPath.row) {
                cell.postPreviewTextLabel.numberOfLines = 0
                cell.expandedButton.setTitle(Constants.buttonTitleSeeLess, for: .normal)
            } else {
                cell.postPreviewTextLabel.numberOfLines = 2
                cell.expandedButton.setTitle(Constants.buttonTitleSeeMore, for: .normal)
            }
        }
        
        cell.buttonClicked = { [unowned self] in
            if expandedCells.contains(indexPath.row) {
                expandedCells.remove(indexPath.row)
            } else {
                expandedCells.insert(indexPath.row)
            }
            
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        return cell
    }
}
