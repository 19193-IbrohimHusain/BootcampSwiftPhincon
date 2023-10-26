//
//  FourthViewController.swift
//  LatihanProfile
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class FourthViewController: UIViewController {

    @IBOutlet weak var segoeNavButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segoeNavButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)

        // Do any additional setup after loading the view.
    }
    
    @objc func btnTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(withIdentifier: "MainViewController")
        self.navigationController?.pushViewController(destinationViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
