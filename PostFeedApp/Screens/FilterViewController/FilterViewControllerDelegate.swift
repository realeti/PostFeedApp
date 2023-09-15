//
//  FilterViewControllerDelegate.swift
//  PostFeedApp
//
//  Created by Apple M1 on 15.09.2023.
//

import Foundation

protocol FilterViewControllerDelegate: AnyObject {
    func sortPostData(sortType: SortType)
}
