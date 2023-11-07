//
//  Constants.swift
//  PostFeedApp
//
//  Created by Apple M1 on 11.09.2023.
//

import Foundation

struct Constants {
    // MARK: Storyboards
    static let storyboardName = "Main"
    static let detailStroboardName = "DetailScreen"
    static let detailViewControllerId = "DetailViewController"
    static let netErrorStoryboardName = "NetErrorScreen"
    static let netErrorViewControllerId = "NetErrorViewController"
    
    // MARK: Main
    static let mainTitle = "Post feed"
    static let netErrorScreenTitle = "Wake up your connection !"
    static let netErrorScreenButtonTitle = "TRY AGAIN"
    
    // MARK: Filter
    static let filterMenuTitle = "Sort by"
    static let filterMenuRatingName = "Rating"
    static let filterMenuDateName = "Newest to oldest"
    static let filterIcon = "icon-filter-bubbles"
    static let filterLikeImage = "heart"
    static let filterDateImage = "clock"
    
    // MARK: Cells
    static let customCellId = "PostFeedCell"
    static let buttonTitleSeeMore = "See More"
    static let buttonTitleSeeLess = "See Less"
    static let postFeedHeartViewTag = 10
    static let postFeedDetailHeartViewTag = 11
    
    // MARK: Coredata
    static let coreDataModelName = "PostFeedDataModel"
    static let postFeedEntityName = "PostFeedCD"
    static let postFeedDetailEntityName = "PostFeedDetailCD"
    
    // MARK: Colors
    static let backgroundColor = "BackgroundColor"
    static let cellBackgroundColor = "CellBackgroundColor"
    static let postTextColor = "PostTextColor"
    static let heartLikeColor = "HeartLikeColor"
    static let postRatingColor = "PostRatingColor"
    static let postAuthorColor = "PostAuthorColor"
    
    private init() {}
}
