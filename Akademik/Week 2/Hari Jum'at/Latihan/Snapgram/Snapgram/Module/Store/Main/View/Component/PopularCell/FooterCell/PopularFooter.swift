//
//  PopularFooter.swift
//  Snapgram
//
//  Created by Phincon on 12/12/23.
//

import UIKit
import RxSwift

class PopularFooter: UICollectionReusableView {
    // MARK: - Variables
    @IBOutlet weak var pageControl: CustomPageControl!
    
    private var bag = DisposeBag()
    
    // MARK: - Lifecycles
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Functions
    internal func subscribeTo(subject: BehaviorSubject<PagingInfo?>, for section: Int) {
        subject
            .filter { $0?.sectionIndex == section }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] pagingInfo in
                guard let self = self, let page = pagingInfo else { return }
                self.pageControl.currentPage = page.currentPage
            }).disposed(by: bag)
    }
}
