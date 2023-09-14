//
//  LoadPosts.swift
//  PostFeedApp
//
//  Created by Apple M1 on 14.09.2023.
//

import Foundation

protocol PostsFetching {
    func fetchPosts(completion: @escaping (Result<[PostData], Error>) -> Void)
}
