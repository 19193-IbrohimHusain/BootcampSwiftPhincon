//
//  ExtNSDirectionalEdgeInsets.swift
//  Snapgram
//
//  Created by Phincon on 07/12/23.
//

import UIKit

extension NSDirectionalEdgeInsets {
    static func uniform(size: CGFloat) -> NSDirectionalEdgeInsets {
        return NSDirectionalEdgeInsets(top: size, leading: size, bottom: size, trailing: size)
    }
    
    init(horizontal: CGFloat, vertical: CGFloat) {
        self.init(top: vertical, leading: horizontal, bottom: vertical, trailing: horizontal)
    }
    
    static func small() -> NSDirectionalEdgeInsets {
        return .uniform(size: 5)
    }
    
    static func medium() -> NSDirectionalEdgeInsets {
        return .uniform(size: 15)
    }
    
    static func large() -> NSDirectionalEdgeInsets {
        return .uniform(size: 30)
    }
}
