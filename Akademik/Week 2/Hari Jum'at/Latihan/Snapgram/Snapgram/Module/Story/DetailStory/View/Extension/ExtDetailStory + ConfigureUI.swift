//
//  ExtDetailStory + ConfigureUI.swift
//  Snapgram
//
//  Created by Phincon on 28/12/23.
//

import Foundation
import UIKit

// MARK: - Extension to ConfigureUI
extension DetailStoryViewController {
    internal func configureUI() {
        guard let validDetail = detailStory else { return }
        navigationItem.title = "\(validDetail.name)'s Post"
        username.text = validDetail.name
        setupUploadedImage(validDetail)
        setupLikeButton(validDetail)
        setupCaption(validDetail)
        commentsCount.text = "\(validDetail.commentsCount) comments"
        setupCreatedAt(validDetail)
        guard validDetail.lat != nil, validDetail.lon != nil else { return }
        setupLocation(validDetail)
    }
    
    private func setupUploadedImage(_ data: Story) {
        uploadedImage.kf.setImage(with: URL(string: data.photoURL), options: [.loadDiskFileSynchronously, .cacheOriginalImage, .transition(.fade(0.25))])
    }
    
    private func setupLikeButton(_ data: Story) {
        likeBtn.setImage(data.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeBtn.tintColor = data.isLiked ? .systemRed : .label
        likesCount.text = "\(data.likesCount) Likes"
    }
    
    private func setupCaption(_ data: Story) {
        let attributedString = NSAttributedString(string: "\(data.name)  \(data.description)")
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let range = NSRange(location: 0, length: data.name.count)
        caption.attributedText = attributedString.applyingAttributes(attributes, toRange: range)
    }
    
    private func setupCreatedAt(_ data: Story) {
        if let date = dateFormatter.date(from: data.createdAt) {
            let timeAgo = date.convertDateToTimeAgo()
            createdAt.text = timeAgo
        }
    }
    
    private func setupLocation(_ data: Story) {
        guard let lat = data.lat, let lon = data.lon else { return }
        getLocationNameFromCoordinates(lat: lat, lon: lon) { [weak self] name in
            guard let self = self else { return }
            let attributedString = NSAttributedString(string: "\(data.name)\n\(name)")
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
            let range = NSRange(location: data.name.count + 1, length: name.count)
            let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
            self.username.attributedText = attributedText
        }
    }
}
