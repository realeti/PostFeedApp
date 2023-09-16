//
//  FallbackController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 16.09.2023.
//

import Foundation

final class PostFallbackController: PostsFetching {
    let mainSource: PostsFetching
    let reserveSource: PostsFetching & PostsStoring
    
    init(mainSource: PostsFetching, reserveSource: PostsFetching & PostsStoring) {
        self.mainSource = mainSource
        self.reserveSource = reserveSource
    }
    
    func fetchPosts(completion: @escaping (Result<[PostFeed], Error>) -> Void) {
        mainSource.fetchPosts { result in
            do {
                let posts = try result.get()
                
                if posts.isEmpty {
                    completion(.failure(NetErrors.invalidData))
                    return
                }
                
                self.reserveSource.storePosts(posts: posts)
                completion(.success(posts))
            } catch {
                self.reserveSource.fetchPosts { reserveResult in
                    do {
                        let reservePosts = try reserveResult.get()
                        
                        completion(.success(reservePosts))
                    } catch {
                        completion(.failure(error))
                    }
                }
            }
        }
    }
}
