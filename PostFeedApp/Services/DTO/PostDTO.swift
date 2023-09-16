//
//  PostFeedDTO.swift
//  PostFeedApp
//
//  Created by Apple M1 on 14.09.2023.
//

import Foundation

struct PostDTO: Codable {
    let posts: [PostFeedDTO]
}

struct PostFeedDTO: Codable {
    let postId: Int
    let timeshamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
    
    enum CodingKeys: String, CodingKey {
        case postId = "postId"
        case timeshamp
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
}
