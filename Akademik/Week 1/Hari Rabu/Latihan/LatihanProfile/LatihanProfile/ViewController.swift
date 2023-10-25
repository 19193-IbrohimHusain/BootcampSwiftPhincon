//
//  ViewController.swift
//  LatihanProfile
//
//  Created by Phincon on 25/10/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        profileImage.layer.cornerRadius = 75
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}

