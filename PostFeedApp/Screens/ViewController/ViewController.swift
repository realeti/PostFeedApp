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
    let expandableCellStorage = ExpandableCellStorage()
    var postData: [PostData] = []

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
        
        let cellIdentifier = Constants.customCellId
        let customCellTypeNib = UINib(nibName: cellIdentifier, bundle: nil)
        tableView.register(customCellTypeNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    private func loadNetworkData() {
        networkController.fetchPosts { [weak self] result in
            do {
                let data = try result.get()
                self?.postData = data
            } catch {
                self?.postData = []
                print(error)
            }
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let filterVC = segue.destination as? FilterViewController else { return }
        
        filterVC.sortType = { [weak self] sort in
            guard let currentSortType = SortType(rawValue: sort) else { return }
            
            switch currentSortType {
            case .newest:
                self?.postData.sort { $0.timeshamp > $1.timeshamp }
            case .rating:
                self?.postData.sort { $0.likesCount > $1.likesCount }
            }
            
            self?.tableView.reloadData()
            self?.presentedViewController?.dismiss(animated: true)
        }
    }
}

extension ViewController: UITableViewDelegate {
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

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.customCellId) as? CustomCell else {
            return UITableViewCell()
        }
        
        let postData = postData[indexPath.row]
        
        cell.config(with: postData) { [weak self] in
            self?.expandableCellStorage.update(for: indexPath)
            self?.tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        expandableCellStorage.configureData(cell, for: indexPath)
        
        return cell
    }
}
