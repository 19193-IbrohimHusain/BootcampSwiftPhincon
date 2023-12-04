import Foundation
import UIKit

enum Edge {
    case left, right, top, bottom
}

extension UICollectionView {
    func scrollToNearestVisibleCollectionViewCell() {
        self.decelerationRate = UIScrollView.DecelerationRate.fast
            let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
            var closestCellIndex = -1
            var closestDistance: Float = .greatestFiniteMagnitude
            for count in 0..<self.visibleCells.count {
                let cell = self.visibleCells[count]
                let cellWidth = cell.bounds.size.width
                let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)

                // Now calculate closest cell
                let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
                if distance < closestDistance {
                    closestDistance = distance
                    closestCellIndex = self.indexPath(for: cell)!.row
                }
            }
            if closestCellIndex != -1 {
                self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            }
        }

    func registerCellWithNib<Cell: UICollectionViewCell>(_ cellClass: Cell.Type) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: .main)
        register(nib, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell<Cell: UICollectionViewCell>(forIndexPath indexPath: IndexPath) -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as? Cell else {
            fatalError("Error for cell if: \(identifier) at \(indexPath)")
        }
        return cell
    }

    func registerHeaderFooterNib<Cell: UICollectionReusableView>(kind: String, _ cellClass: Cell.Type) {
        let identifier = String(describing: cellClass)
        let nib = UINib(nibName: identifier, bundle: .main)
        register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: identifier)
    }
    
    func near(edge: Edge, clearance: CGFloat = 0) -> Bool {
        switch edge {
        case .left:
            return contentOffset.x + contentInset.left - clearance <= 0
        case .right:
            return (contentOffset.x + bounds.width + clearance) >= contentSize.width
        case .top:
            return contentOffset.y + contentInset.top - clearance <= 0
        case .bottom:
            return (contentOffset.y + bounds.height + clearance) >= contentSize.height
        }
    }
    
}
