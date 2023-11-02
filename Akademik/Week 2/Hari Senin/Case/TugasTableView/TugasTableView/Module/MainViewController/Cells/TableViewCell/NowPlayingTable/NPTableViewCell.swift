import UIKit

class NPTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nowPlayingTitle: UILabel!
    @IBOutlet weak var nowPlayingCollection: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        nowPlayingCollection.dataSource = self
        nowPlayingCollection.delegate = self
        nowPlayingCollection.registerCellWithNib(NowPlayingCollectionViewCell.self)
    }
}

extension NPTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as NowPlayingCollectionViewCell
        
        return cell;
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionViewWidth = collectionView.bounds.width
        return CGSize(width: collectionViewWidth, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
