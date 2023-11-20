import UIKit

class CategoryTableCell: UITableViewCell {

    @IBOutlet weak var categoryCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        categoryCollection.registerCellWithNib(CategoryCollectionCell.self)
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension CategoryTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryItem.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CategoryCollectionCell
        let categoryEntity = categoryItem[indexPath.row]
        cell.configureCollection(categoryEntity)
        
        return cell
    }
}
