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
    
    private var collections = SectionPostCollection.allCases
    internal var delegate: PostTableCellDelegate?
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
            heightCollection.constant = collectionView.contentSize.height
            return cell
        case .tagged:
            let cell1 = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TaggedPostCollectionCell
            cell1.delegate = self
            if let data = tagged {
                cell1.configure(data: data)
            }
            heightCollection.constant = collectionView.contentSize.height
            return cell1
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width
        let itemHeight = collectionView.bounds.height
        return CGSize(width: itemWidth, height: itemHeight)
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
