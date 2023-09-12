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
    
    var sortType: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
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
        sortType?(currentSortType.rawValue)
        
        switch currentSortType {
        case .newest:
            filterItemDate.accessoryType = .checkmark
            filterItemRating.accessoryType = .none
        case .rating:
            filterItemDate.accessoryType = .none
            filterItemRating.accessoryType = .checkmark
        }
    }
}
