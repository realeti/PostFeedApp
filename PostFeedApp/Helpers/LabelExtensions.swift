//
//  LabelExtensions.swift
//  PostFeedApp
//
//  Created by Apple M1 on 11.09.2023.
//

import UIKit

extension UILabel {
    var countOfLines: Int {
        guard let text = self.text else { return 0 }
        
        let rect = CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedString.Key.font : self.font]
        let labelSize = text.boundingRect(
            with: rect,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes as [NSAttributedString.Key : Any],
            context: nil)
        
        return Int(ceil(CGFloat(labelSize.height) / self.font.lineHeight))
    }
}
