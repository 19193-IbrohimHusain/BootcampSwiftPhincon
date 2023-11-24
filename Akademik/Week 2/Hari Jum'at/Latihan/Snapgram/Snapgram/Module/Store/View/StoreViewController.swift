//
//  FolderViewController.swift
//  Snapgram
//
//  Created by Phincon on 03/11/23.
//

import UIKit

class StoreViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupNavigationBar() {
        self.navigationItem.style = .navigator
        self.navigationController?.navigationBar.tintColor = .label
        self.navigationItem.setLeftBarButton(UIBarButtonItem(customView: configureNavigationTitle(title: "SnapStore")), animated: false)
        self.navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "cart"), style: .plain, target: self, action: nil)
        ]
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
