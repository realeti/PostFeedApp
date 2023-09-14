//
//  PostDate.swift
//  PostFeedApp
//
//  Created by Apple M1 on 11.09.2023.
//

import Foundation

extension Date {
    var fullDateDisplay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        
        return formatter.string(from: self)
    }
}
