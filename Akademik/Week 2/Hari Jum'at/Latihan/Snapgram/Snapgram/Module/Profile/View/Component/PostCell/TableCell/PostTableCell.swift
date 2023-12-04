import UIKit

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
    internal var post: [ListStory]?
        
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollection()
    }
    
    func setupCollection() {
        postCollection.delegate = self
        postCollection.dataSource = self
        postCollection.collectionViewLayout = createLayout()
        collections.forEach { cell in
            postCollection.registerCellWithNib(cell.cellTypes)
        }
        heightCollection.constant = 450
    }
    
    func configure(data: [ListStory]) {
        self.post = data
        postCollection.reloadData()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let sectionProvider: UICollectionViewCompositionalLayoutSectionProvider = { [weak self] sectionIndex, _ in
            guard let self = self, let sectionKind = SectionPostCollection(rawValue: sectionIndex) else { return nil }

            let section: NSCollectionLayoutSection

            switch sectionKind {
            case .post:
                
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(self.postCollection.bounds.width / 3),
                    heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(self.postCollection.bounds.width / 3),
                    heightDimension: .absolute(self.heightCollection.constant))
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                                
            case .tagged:
                let layoutSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(self.postCollection.bounds.width / 3),
                    heightDimension: .absolute(150))
                let item = NSCollectionLayoutItem(layoutSize: layoutSize)
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .absolute(self.postCollection.bounds.width / 3),
                    heightDimension: .absolute(self.heightCollection.constant))

                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item])
                
                section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .none
                
            }

            return section
        }

        // Define a layout configuration
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.scrollDirection = .horizontal

        // Create the compositional layout using the initializer
        let compositionalLayout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider,
            configuration: configuration
        )
        return compositionalLayout
    }
}

extension PostTableCell: UICollectionViewDelegate, UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        collections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionCollection = SectionPostCollection(rawValue: section)
        switch sectionCollection {
        case .post:
            return post?.count ?? 0
        case .tagged:
            return post?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionCollection = SectionPostCollection(rawValue: indexPath.section)
        switch sectionCollection {
        case .post:
            let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as PostCollectionCell
            if let dataPost = post {
                let postEntity = dataPost[indexPath.item]
                cell.configureCollection(postEntity)
                heightCollection.constant = collectionView.contentSize.height
            }
            return cell
        case .tagged:
            let cell1 = collectionView.dequeueReusableCell(forIndexPath: indexPath) as TaggedPostCollectionCell
            if let dataPost = post {
                let postEntity = dataPost[indexPath.item]
                cell1.configureCollection(postEntity)
                heightCollection.constant = collectionView.contentSize.height
            }

            return cell1
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let storyID = post?[index].id {
            self.delegate?.navigateToDetail(id: storyID)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.didScroll(scrollView: scrollView)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.delegate?.willEndDragging(contentOffset: targetContentOffset)
    }
}
