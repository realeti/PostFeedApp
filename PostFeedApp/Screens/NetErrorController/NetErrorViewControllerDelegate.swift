//
//  NetErrorViewControllerDelegate.swift
//  PostFeedApp
//
//  Created by Apple M1 on 15.09.2023.
//

import Foundation

protocol NetErrorViewControllerDelegate: AnyObject {
    func showErrorScreen(_ error: String)
    func loadNetworkData()
}
