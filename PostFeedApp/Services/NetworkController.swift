//
//  NetworkController.swift
//  PostFeedApp
//
//  Created by Apple M1 on 31.08.2023.
//

import Foundation
import Alamofire

class NetworkController {
    
    let mainUrl = "https://raw.githubusercontent.com/"
    
    func fetchPosts(completion: @escaping (Result<[PostData], Error>) -> ()) {
        let path = "anton-natife/jsons/master/api/main.json"
        let url = mainUrl.appending(path)
        
        AF.request(url).responseDecodable(of: PostFeed.self) { responce in
            switch responce.result {
            case .success(let data):
                completion(.success(data.posts))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchPostDetail(_ postId: Int, completion: @escaping (Result<PostDetailData, Error>) ->()) {
        let path = "anton-natife/jsons/master/api/posts/\(postId).json"
        let url = mainUrl.appending(path)
        
        AF.request(url).responseDecodable(of: PostFeedDetail.self) { responce in
            switch responce.result {
            case .success(let data):
                completion(.success(data.post))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
