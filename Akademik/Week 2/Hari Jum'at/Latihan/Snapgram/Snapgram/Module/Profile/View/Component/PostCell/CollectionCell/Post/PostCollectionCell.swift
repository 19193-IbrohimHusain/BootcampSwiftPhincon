import UIKit
import SkeletonView

protocol PostCollectionCellDelegate {
    func navigateToDetail(id: String)
}

class PostCollectionCell: UICollectionViewCell {

    @IBOutlet weak var postCollection: UICollectionView!
    
    internal var delegate: PostCollectionCellDelegate?
    internal var post: [ListStory]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    private func setupCollection() {
        postCollection.delegate = self
        postCollection.dataSource = self
        postCollection.registerCellWithNib(PostPhotoCell.self)
    }
    
    internal func configure(data: [ListStory]) {
        self.post = data
        postCollection.reloadData()
    }
}

extension PostCollectionCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PostPhotoCell
        if let dataPost = post?[indexPath.item] {
            cell.configureCollection(dataPost)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let storyID = post?[indexPath.item].id {
            self.delegate?.navigateToDetail(id: storyID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = collectionView.bounds.width / 3
        return CGSize(width: itemWidth, height: 150)
    }
}

extension PostCollectionCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: PostPhotoCell.self)
    }
}
