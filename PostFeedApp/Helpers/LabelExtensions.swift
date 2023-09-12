//
//  LabelExtensions.swift
//  PostFeedApp
//
//  Created by Apple M1 on 11.09.2023.
//

import UIKit

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font as Any], context: nil).height
        let lineHeight = font.lineHeight
        
        return Int(ceil(textHeight / lineHeight)) - 1
    }
}
