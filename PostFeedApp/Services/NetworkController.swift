//
//  NetworkController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import Foundation
import Alamofire

class NetworkController: PostsFetching, PostsDetailFetching {
    
    enum NetErrors: Error {
        case statusCode(Int)
        case invalidURL
        case badResponce
        case other
    }
    
    let mainUrl = "https://raw.githubusercontent.com/"
    
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
            if let error {
                completion(.failure(error))
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
                completion(.failure(NetErrors.other))
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
    
    func fetchPosts(completion: @escaping (Result<[PostData], Error>) -> Void) {
        let path = "anton-natife/jsons/master/api/main.json"
        
        fetchData(path: path) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode(PostFeedDTO.self, from: data)
                let postsDto = responseData.posts
                
                let posts = postsDto.map { post in
                    PostData(postId: post.postId,
                             timeshamp: post.timeshamp,
                             title: post.title,
                             previewText: post.previewText,
                             likesCount: post.likesCount
                    )
                }
                
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func fetchPostDetail(_ postId: Int, completion: @escaping (Result<PostFeedDetail, Error>) -> Void) {
        let path = "anton-natife/jsons/master/api/posts/\(postId).json"
        
        fetchData(path: path) { response in
            do {
                let data = try response.get()
                let responseData = try self.decoder.decode(PostFeedDetailDTO.self, from: data)
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
