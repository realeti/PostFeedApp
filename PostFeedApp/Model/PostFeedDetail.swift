//
//  PostFeedDetail.swift
//  PostFeedApp
//
//  Created by Apple M1 on 01.09.2023.
//

import Foundation

struct PostFeedDetail: Codable {
    let post: PostDetailData
}

struct PostDetailData: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let text: String
    let postImage: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case timeshamp = "timeshamp"
        case title = "title"
        case text = "text"
        case postImage = "postImage"
        case likesCount = "likes_count"
    }
}
