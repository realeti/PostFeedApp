//
//  CellsDataStore.swift
//  PostFeedApp
//
//  Created by Apple M1 on 12.09.2023.
//

import UIKit

class ExpandableCellStorage {
    var expandableCells: IndexSet = []
    var cellWidths: [Int: CGFloat] = [:]
    
    func configureData(_ cell: PostFeedCell, for postId: Int, _ viewWidth: CGFloat) {
        if cellWidths[postId] == nil {
            let intrinsicPreviewTextWidth = cell.postPreviewTextLabel.intrinsicContentSize.width
            cellWidths[postId] = intrinsicPreviewTextWidth
        }
        
        let cellWidth = cellWidths[postId] ?? 0
        
        if cellWidth < viewWidth * 2 {
            cell.expandedButton.isHidden = true
        } else {
            cell.expandedButton.isHidden = false
            
            if expandableCells.contains(postId) {
                cell.postPreviewTextLabel.numberOfLines = 5
                cell.expandedButton.setTitle(Constants.buttonTitleSeeLess, for: .normal)
            } else {
                cell.postPreviewTextLabel.numberOfLines = 2
                cell.expandedButton.setTitle(Constants.buttonTitleSeeMore, for: .normal)
            }
        }
    }
    
    func update(for postId: Int) {
        if expandableCells.contains(postId) {
            expandableCells.remove(postId)
        } else {
            expandableCells.insert(postId)
        }
    }
}
