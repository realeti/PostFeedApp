//
//  PostFeedCellDelegate.swift
//  PostFeedApp
//
//  Created by Apple M1 on 15.09.2023.
//

import Foundation

protocol PostFeedCellDelegate: AnyObject {
    func buttonPressed(indexPath: IndexPath, postId: Int)
}
