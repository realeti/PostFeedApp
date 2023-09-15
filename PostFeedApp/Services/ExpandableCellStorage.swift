//
//  CellsDataStore.swift
//  PostFeedApp
//
//  Created by Apple M1 on 12.09.2023.
//

import UIKit

class ExpandableCellStorage {
    private var longCells: IndexSet = []
    var expandableCells: IndexSet = []
    
    func configureData(_ cell: PostFeedCell, for indexPath: IndexPath) {
        if cell.postPreviewTextLabel.maxNumberOfLines <= 2 && !longCells.contains(indexPath.row) {
            cell.expandedButton.isHidden = true
        } else {
            cell.expandedButton.isHidden = false
            longCells.insert(indexPath.row)
            
            if expandableCells.contains(indexPath.row) {
                cell.postPreviewTextLabel.numberOfLines = 0
                cell.expandedButton.setTitle(Constants.buttonTitleSeeLess, for: .normal)
            } else {
                cell.postPreviewTextLabel.numberOfLines = 2
                cell.expandedButton.setTitle(Constants.buttonTitleSeeMore, for: .normal)
            }
        }
    }
    
    func update(for indexPath: IndexPath) {
        if expandableCells.contains(indexPath.row) {
            expandableCells.remove(indexPath.row)
        } else {
            expandableCells.insert(indexPath.row)
        }
    }
}
