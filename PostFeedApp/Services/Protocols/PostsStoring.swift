//
//  PostsStoring.swift
//  PostFeedApp
//
//  Created by Apple M1 on 16.09.2023.
//

import Foundation

protocol PostsStoring {
    func storePosts(posts: [PostFeed])
}
