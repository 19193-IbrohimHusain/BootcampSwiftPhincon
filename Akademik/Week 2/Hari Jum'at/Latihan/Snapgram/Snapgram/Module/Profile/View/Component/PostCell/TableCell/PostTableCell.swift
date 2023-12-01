import UIKit

protocol PostTableCellDelegate {
    func navigateToDetail(id: String)
}

class PostTableCell: UITableViewCell {

    @IBOutlet weak var postCollection: UICollectionView!
    
    @IBOutlet weak var heightCollection: NSLayoutConstraint!
    
    internal var delegate: PostTableCellDelegate?
    internal var post: [ListStory]?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        postCollection.delegate = self
        postCollection.dataSource = self
        postCollection.registerCellWithNib(PostCollectionCell.self)
        heightCollection.constant = 450

    }
    
    func configure(data: [ListStory]) {
        self.post = data
        postCollection.reloadData()
    }
}

extension PostTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let dataPost = post {
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PostCollectionCell
            let postEntity = dataPost[indexPath.row]
            cell.configureCollection(postEntity)
            heightCollection.constant = collectionView.contentSize.height
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        let itemWidth = collectionViewWidth / 3.0
        return CGSize(width: itemWidth, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        if let storyID = post?[index].id {
            self.delegate?.navigateToDetail(id: storyID)
        }
    }
}
