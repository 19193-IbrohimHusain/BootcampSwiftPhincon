import UIKit

protocol TopRatedTableViewCellDelegate {
    func didTapCell()
}

class TopRatedTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topRatedTitle: UILabel!
    @IBOutlet weak var topRatedCollection: UICollectionView!
    
    var delegate: TopRatedTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        topRatedCollection.dataSource = self
        topRatedCollection.delegate = self
        topRatedCollection.registerCellWithNib(TopRatedCollectionViewCell.self)
    }
}

extension TopRatedTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TopRatedCollectionViewCell
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.didTapCell()
    }
}
