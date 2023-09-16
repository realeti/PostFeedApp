//
//  FetchData.swift
//  PostFeedApp
//
//  Created by Apple M1 on 16.09.2023.
//

import Foundation

protocol FetchData: PostsFetching, PostsStoring, PostDetailFetching, PostDetailStoring {}
