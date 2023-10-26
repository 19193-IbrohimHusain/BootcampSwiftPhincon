//
//  StoryTableViewController.swift
//  LatihanProfile
//
//  Created by Phincon on 26/10/23.
//

import UIKit

class StoryTableViewController: UIViewController {

    @IBOutlet weak var storyTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()

        // Do any additional setup after loading the view.
    }

    func setupTable(){
        storyTable.delegate = self
        storyTable.dataSource = self
        storyTable.registerCellWithNib(StoryTableCell.self)
    }
}

extension StoryTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as StoryTableCell
        return cell
    }
}
