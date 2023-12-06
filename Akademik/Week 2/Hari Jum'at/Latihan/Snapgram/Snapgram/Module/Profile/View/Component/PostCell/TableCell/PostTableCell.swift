import UIKit
import SkeletonView

protocol PostTableCellDelegate {
    func didScroll(scrollView: UIScrollView)
    func willEndDragging(contentOffset: UnsafeMutablePointer<CGPoint>)
    func navigateToDetail(id: String)
}

class PostTableCell: UITableViewCell {

    @IBOutlet weak var postCollection: UICollectionView!
    
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    
    internal var delegate: PostTableCellDelegate?
    private var collections = SectionPostCollection.allCases
    private var postHeight = CGFloat()
    private var tagHeight = CGFloat()
    private var tagged: [ListStory]?
    private var post: [ListStory]?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        postCollection.delegate = self
        postCollection.dataSource = self
        collections.forEach { cell in
            postCollection.registerCellWithNib(cell.cellTypes)
        }
    }
    
    func configure(post: [ListStory], tag: [ListStory]) {
        self.post = post
        self.tagged = tag
        postCollection.collectionViewLayout.invalidateLayout()
        postCollection.reloadData()
    }
}

extension PostTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionCollection = SectionPostCollection(rawValue: section)
        switch sectionCollection {
        case .post, .tagged:
            return 1
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionCollection = SectionPostCollection(rawValue: indexPath.section)
        switch sectionCollection {
        case .post:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PostCollectionCell
            cell.delegate = self
            if let data = post {
                cell.configure(data: data)
            }
            cell.heightConstant.constant = self.heightCollection.constant
            cell.collectionView.collectionViewLayout.invalidateLayout()
            return cell
        case .tagged:
            let cell1 = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TaggedPostCollectionCell
            cell1.delegate = self
            if let data = tagged {
                cell1.configure(data: data)
            }
            cell1.heightCollection.constant = self.heightCollection.constant
            cell1.tagCollection.collectionViewLayout.invalidateLayout()
            return cell1
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionCollection = SectionPostCollection(rawValue: indexPath.section)
        switch sectionCollection {
        case .post:
            let itemWidth = collectionView.bounds.width
            let itemHeight = self.heightCollection.constant
            return CGSize(width: itemWidth, height: itemHeight)
        case .tagged:
            let itemWidth = collectionView.bounds.width
            let itemHeight = self.heightCollection.constant
            return CGSize(width: itemWidth, height: itemHeight)
        default:
            return CGSize()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.didScroll(scrollView: scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.delegate?.willEndDragging(contentOffset: targetContentOffset)
    }
}

extension PostTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: PostCollectionCell.self)
    }
}

extension PostTableCell: PostCollectionCellDelegate, TaggedPostCollectionCellDelegate {
    func navigateToDetail(id: String) {
        self.delegate?.navigateToDetail(id: id)
    }
}
