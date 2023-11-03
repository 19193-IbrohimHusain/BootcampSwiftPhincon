//
//  ProfileBottomSheetViewController.swift
//  Snapgram
//
//  Created by Phincon on 03/11/23.
//

import UIKit

protocol ProfileBottomSheetViewControllerDelegate {
    func removeProfilePic()
    func showChoice()
}

class ProfileBottomSheetViewController: UIViewController {

    @IBOutlet weak var newProfilePic: UIStackView!
    @IBOutlet weak var removeProfilePic: UIStackView!
    
    var delegate: ProfileBottomSheetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBottomSheet()
    }
    
    func setBottomSheet() {
        // New Profile Pic Gesture
        let newProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(newProfile))
        newProfilePic.isUserInteractionEnabled = true
        newProfilePic.addGestureRecognizer(newProfileTapGesture)
        
        // Remove Profile Pic Gesture
        let removeProfileTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeProfile))
        removeProfilePic.isUserInteractionEnabled = true
        removeProfilePic.addGestureRecognizer(removeProfileTapGesture)
    }
    
    @objc func newProfile(_ sender: UITapGestureRecognizer) {
        self.delegate?.showChoice()
    }
    
    @objc func removeProfile(_ sender: UITapGestureRecognizer) {
        self.delegate?.removeProfilePic()
    }
}
