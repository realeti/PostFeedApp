//
//  PostDetailFallbackController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 16.09.2023.
//

import Foundation

final class PostDetailFallbackController: PostDetailFetching {
    let mainSource: PostDetailFetching
    let reserveSource: PostDetailFetching & PostDetailStoring
    
    init(mainSource: PostDetailFetching, reserveSource: PostDetailFetching & PostDetailStoring) {
        self.mainSource = mainSource
        self.reserveSource = reserveSource
    }
    
    func fetchPostDetail(_ postId: Int, completion: @escaping (Result<PostFeedDetail, Error>) -> Void) {
        mainSource.fetchPostDetail(postId) { result in
            do {
                let post = try result.get()
                
                self.reserveSource.storeDetailPost(post: post)
                completion(.success(post))
            } catch {
                self.reserveSource.fetchPostDetail(postId) { result in
                    do {
                        let reservePost = try result.get()
                        completion(.success(reservePost))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
