//
//  FilterController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 03.09.2023.
//

import UIKit

class FilterController: UITableViewController {
    
    var sortType: ((Int) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var filterItemDate: UITableViewCell!
    @IBOutlet weak var filterItemRating: UITableViewCell!
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        sortType?(indexPath.row)
        
        switch indexPath.row {
        case 0:
            filterItemDate.accessoryType = .checkmark
            filterItemRating.accessoryType = .none
        case 1:
            filterItemDate.accessoryType = .none
            filterItemRating.accessoryType = .checkmark
        default:
            filterItemDate.accessoryType = .none
            filterItemRating.accessoryType = .none
        }
    }
}
