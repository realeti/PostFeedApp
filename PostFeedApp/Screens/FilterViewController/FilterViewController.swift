//
//  FilterController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 03.09.2023.
//

import UIKit

class FilterViewController: UITableViewController {
    
    @IBOutlet weak var filterItemDate: UITableViewCell!
    @IBOutlet weak var filterItemRating: UITableViewCell!
    
    weak var delegate: FilterViewControllerDelegate?
    var currentSortType: SortType?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        if let currentSortType {
            configure(sortType: currentSortType)
        }
    }
    
    func configure(sortType: SortType) {
        switch sortType {
        case .newest:
            filterItemDate.accessoryType = .checkmark
            filterItemRating.accessoryType = .none
        case .rating:
            filterItemDate.accessoryType = .none
            filterItemRating.accessoryType = .checkmark
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let currentSortType = SortType(rawValue: indexPath.row) else { return }
        
        configure(sortType: currentSortType)
        delegate?.sortPostData(sortType: currentSortType)
    }
}
