//
//  PostDate.swift
//  PostFeedApp
//
//  Created by Apple M1 on 11.09.2023.
//

import Foundation

extension Date {
    func fullDateDisplay() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM YYYY"
        
        return formatter.string(from: self)
    }
}

extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
