//
//  CustomErrorVIew.swift
//  Snapgram
//
//  Created by Phincon on 01/12/23.
//

import UIKit
import Lottie

class CustomErrorView: UIView {
    private let animationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.backgroundColor = .systemBackground
        animationView.contentMode = .scaleToFill
        animationView.animation = LottieAnimation.named("error_animation")
        return animationView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Uh oh! Something's wrong!"
        label.font = UIFont(name: "Helvetica-Bold", size: 14)
        return label
    }()

    internal var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Please pull to refresh"
        label.font = UIFont(name: "Helvetica", size: 12)
        return label
    }()

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureAnimation()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureAnimation()
    }

    // MARK: - Functions

    private func configureView() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: frame.width),
            heightAnchor.constraint(equalToConstant: frame.height),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.heightAnchor.constraint(equalToConstant: 400),

            titleLabel.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descriptionLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func configureAnimation() {
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.play()
    }
}
