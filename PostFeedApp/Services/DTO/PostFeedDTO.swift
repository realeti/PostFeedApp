//
//  PostFeedDTO.swift
//  PostFeedApp
//
//  Created by Apple M1 on 14.09.2023.
//

import Foundation

struct PostFeedDTO: Codable {
    let posts: [PostDataDTO]
}

struct PostDataDTO: Codable {
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
