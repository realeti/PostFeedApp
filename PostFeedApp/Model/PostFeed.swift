//
//  PostFeed.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import Foundation

struct PostFeed: Codable {
    let posts: [PostData]
}

struct PostData: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case timeshamp = "timeshamp"
        case title = "title"
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}
