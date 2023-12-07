//
//  CarouselTableCell.swift
//  Snapgram
//
//  Created by Phincon on 28/11/23.
//

import UIKit
import SkeletonView

protocol CarouselTableCellDelegate {
    func navigateToDetail(id: Int)
}
class CarouselTableCell: UITableViewCell {

    @IBOutlet weak var carouselCollection: UICollectionView!
    @IBOutlet weak var customPageControl: CustomPageControl!
    
    internal var delegate: CarouselTableCellDelegate?
    private var currentIndex = 0
    private var timer: Timer?
    private var product: [ProductModel]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        customPageControl.numberOfPages = product?.count ?? 5
        carouselCollection.delegate = self
        carouselCollection.dataSource = self
        carouselCollection.registerCellWithNib(CarouselCollectionCell.self)
    }
    
    internal func configure(data: [ProductModel]) {
        self.product = data
        carouselCollection.reloadData()
        startTimer()
    }
    
    // MARK: - Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc private func timerAction() {
        currentIndex =  (currentIndex + 1) % (product?.count ?? 5)
        carouselCollection.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}

extension CarouselTableCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return product?.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(forIndexPath: indexPath) as CarouselCollectionCell
        let item = product?[indexPath.item]
        item?.galleries?.forEach { carousel in
            cell.configure(with: carousel)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.item
        if let productID = product?[index].id {
            self.delegate?.navigateToDetail(id: productID)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == carouselCollection {
            customPageControl.scrollViewDidScroll(scrollView)
            currentIndex = Int(scrollView.contentOffset.x / scrollView.frame.width)
            customPageControl.currentPage = currentIndex
        }
    }
}

extension CarouselTableCell: SkeletonCollectionViewDataSource {
    func collectionSkeletonView(_ skeletonView: UICollectionView, cellIdentifierForItemAt indexPath: IndexPath) -> SkeletonView.ReusableCellIdentifier {
        return String(describing: CarouselCollectionCell.self)
    }
}
