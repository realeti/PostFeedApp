//
//  PostsDetailFetch.swift
//  PostFeedApp
//
//  Created by Apple M1 on 14.09.2023.
//

import Foundation

protocol PostsDetailFetching {
    func fetchPostDetail(_ postId: Int, completion: @escaping (Result<PostFeedDetail, Error>) -> Void)
}
