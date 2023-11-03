import UIKit

class CustomInputField: UIView {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    // MARK: - Functions
    private func configureView() {
        let view = self.loadNib()
        view.frame = self.bounds
        view.backgroundColor = .white
        self.addSubview(view)
    }
    
    @IBAction func inputTapTextArea() {
        textField.becomeFirstResponder()
    }
    
    @IBAction func didEndEditing() {
        textField.resignFirstResponder()
//        let view = self.loadNib()
//        view.endEditing(true)
    }
    
    func setup(placeholder: String, errorText: String) {
        textField.placeholder = placeholder
        errorLabel.text = errorText
        errorLabel.isHidden = true
    }
    
}
