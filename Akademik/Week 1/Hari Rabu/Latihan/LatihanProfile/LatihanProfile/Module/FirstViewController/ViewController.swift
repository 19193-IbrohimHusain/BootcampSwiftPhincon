//
//  ViewController.swift
//  LatihanProfile
//
//  Created by Phincon on 25/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var navButton: UIButton!
    
    override func viewDidLoad() {
        profileImage.layer.cornerRadius = 75
        navigationItem.hidesBackButton = true
        super.viewDidLoad()
        navButton.addTarget(self, action: #selector(btnTap), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc func btnTap() {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController")
        let vc = StoryTableViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

