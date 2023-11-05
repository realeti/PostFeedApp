//
//  NetworkController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import Foundation

enum NetErrors: Error {
    case statusCode(Int)
    case invalidURL
    case invalidData
    case badResponce
    case wrongDecode
    case connectionProblem
}

class NetworkController: PostsFetching, PostDetailFetching {
    
    let mainUrl = "https://realeti.github.io/sample-jsons/"
    
    let session = URLSession.shared
    let headers = ["accept": "application/json"]
    
    lazy var decoder = JSONDecoder()
    
    func fetchData(fullPath: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: fullPath) else {
            completion(.failure(NetErrors.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let _ = error {
                completion(.failure(NetErrors.connectionProblem))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NetErrors.badResponce))
                return
            }
            
            let statusCode = httpResponse.statusCode
            
            guard (200..<300).contains(statusCode) else {
                completion(.failure(NetErrors.statusCode(statusCode)))
                return
            }
            
            guard let data else {
                completion(.failure(NetErrors.invalidData))
                return
            }
            
            completion(.success(data))
        }
        dataTask.resume()
    }
    
    func fetchData(path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let urlString = mainUrl.appending(path)
        fetchData(fullPath: urlString, completion: completion)
    }
    
    func fetchPosts(completion: @escaping (Result<[PostFeed], Error>) -> Void) {
        let path = "postfeed-api/main.json"
        
        fetchData(path: path) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode(PostDTO.self, from: data)
                let postsDto = responseData.posts
                
                let posts = postsDto.map { post in
                    PostFeed(postId: post.postId,
                             timeshamp: post.timeshamp,
                             title: post.title,
                             previewText: post.previewText,
                             likesCount: post.likesCount,
                             commentsCount: post.commentsCount,
                             authorName: post.authorName,
                             authorAvatar: post.authorAvatar
                    )
                }
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchPostDetail(_ postId: Int, completion: @escaping (Result<PostFeedDetail, Error>) -> Void) {
        let path = "postfeed-api/posts/\(postId).json"
        
        fetchData(path: path) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode(PostDetailDTO.self, from: data)
                let detailPostDto = responseData.post
                
                let detailPost = PostFeedDetail(postId: detailPostDto.postId,
                                                timeshamp: detailPostDto.timeshamp,
                                                title: detailPostDto.title,
                                                text: detailPostDto.text,
                                                postImage: detailPostDto.postImage,
                                                likesCount: detailPostDto.likesCount
                )
                
                completion(.success(detailPost))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
