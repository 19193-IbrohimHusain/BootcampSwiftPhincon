import UIKit
import FloatingPanel

class CommentViewController: UIViewController {
    
    @IBOutlet weak var commentTable: UITableView!
    @IBOutlet weak var emojiCollection: UICollectionView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var gifBtn: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup() {
        commentTable.delegate = self
        commentTable.dataSource = self
        commentTable.registerCellWithNib(CommentTableCell.self)
    }
    
//    func updateView(viewType: BottomSheetViewTypes) {
//        switch viewType {
//        case .half:
//            self.bottomView.isHidden = false
//            self.
//        case .full:
//            self.bottomView.isHidden = false
//        default: break
//
//        }
//
//        UIView.animate(withDuration: 2, delay: 0.1, options: .curveEaseInOut) {
//            self.view.layoutIfNeeded()
//
//            switch viewType {
//            case .tip:
//                self.halfView.alpha(0)
//                self.fullView.alpha(0)
//            case .half:
//                self.halfView.alpha(1)
//                self.fullView.alpha(0)
//            case .full:
//                self.halfView.alpha(0)
//                self.fullView.alpha(1)
//            }
//        }
//    }
}

extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 40
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as CommentTableCell
        
        return cell
    }
}
