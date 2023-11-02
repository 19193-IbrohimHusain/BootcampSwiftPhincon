import UIKit

class PopularTableViewCell: UITableViewCell {
    
    @IBOutlet weak var popularTitle: UILabel!
    @IBOutlet weak var popularCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        popularCollection.dataSource = self
        popularCollection.delegate = self
        popularCollection.registerCellWithNib(PopularCollectionViewCell.self)
    }
}

extension PopularTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PopularCollectionViewCell
        
        return cell
    }
}
