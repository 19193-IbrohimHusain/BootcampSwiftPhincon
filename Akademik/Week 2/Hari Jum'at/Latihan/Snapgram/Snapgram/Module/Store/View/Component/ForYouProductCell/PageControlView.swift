//
//  PageControlView.swift
//  Snapgram
//
//  Created by Phincon on 11/12/23.
//

import Foundation
import UIKit

class PageControlSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = "pageControl"

    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = UIColor.label
        pageControl.pageIndicatorTintColor = UIColor.systemGray5
        pageControl.currentPage = 0
        return pageControl
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupPageControl()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupPageControl()
    }

    private func setupPageControl() {
        addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
