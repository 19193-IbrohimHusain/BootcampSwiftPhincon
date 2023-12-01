//
//  DetailProductViewModel.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import Foundation
import RxSwift

enum SectionDetailProductTable: Int, CaseIterable {
    case image, name, desc, store, recommendation
    
    var cellTypes: UITableViewCell.Type {
        switch self {
        case .image:
            return DetailImageTableCell.self
        case .name:
            return DetailNameTableCell.self
        case .desc:
            return DetailDescriptionTableCell.self
        default: return UITableViewCell.self
        }
    }
}
