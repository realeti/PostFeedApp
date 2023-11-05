//
//  Constants.swift
//  PostFeedApp
//
//  Created by Apple M1 on 11.09.2023.
//

import Foundation

struct Constants {
    static let storyboardName = "Main"
    static let detailStroboardName = "DetailScreen"
    static let detailViewControllerId = "DetailViewController"
    static let netErrorStoryboardName = "NetErrorScreen"
    static let netErrorViewControllerId = "NetErrorViewController"
    static let customCellId = "PostFeedCell"
    static let mainTitle = "Post feed"
    static let buttonTitleSeeMore = "See More"
    static let buttonTitleSeeLess = "See Less"
    static let netErrorScreenTitle = "Wake up your connection !"
    static let netErrorScreenButtonTitle = "TRY AGAIN"
    static let postFeedHeartViewTag = 10
    static let postFeedDetailHeartViewTag = 11
    static let coreDataModelName = "PostFeedDataModel"
    static let postFeedEntityName = "PostFeedCD"
    static let postFeedDetailEntityName = "PostFeedDetailCD"
    static let filterMenuTitle = "Sort by"
    static let filterMenuRatingName = "Rating"
    static let filterMenuDateName = "Newest to oldest"
    
    private init() {}
}
