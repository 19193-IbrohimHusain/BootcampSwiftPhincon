//
//  SectionProfileTable.swift
//  Snapgram
//
//  Created by Phincon on 28/12/23.
//

import Foundation
import UIKit

enum SectionProfileTable: Int, CaseIterable {
    case profile, category, post
    
    internal var cellTypes: UITableViewCell.Type {
        switch self {
        case .profile:
            return ProfileTableCell.self
        case .category:
            return CategoryTableCell.self
        case .post:
            return PostTableCell.self
        }
    }
}
