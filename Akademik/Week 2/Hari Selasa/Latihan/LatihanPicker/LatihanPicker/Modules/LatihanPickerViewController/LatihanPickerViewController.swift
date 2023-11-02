import UIKit
import StepSlider

class LatihanPickerViewController: UIViewController {

    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var stepSlider: StepSlider!
    @IBOutlet weak var progress: UIProgressView!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var result: UILabel!
    @IBOutlet weak var desc: UILabel!
    
    var hours: [String] = []
    let minutes = Array(0...59).map{ String(format: "%02d", $0)}
    let ampm = ["AM", "PM"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        navigationItem.title = "Test Picker View"
        result.text = "Test Hasil :"
        
        setupHorizontalSlider()
        setupStepSlider()
        setupSwitchButton()
        setupProgressView()
        setupPickerView()
    }
    
    func setupStepSlider() {
        stepSlider.index = 0
        stepSlider.sliderCircleColor = UIColor.red
        
        stepSlider.addTarget(self, action: #selector(stepSliderValueChanged), for: .valueChanged)
    }
    
    @objc func stepSliderValueChanged() {
        desc.text = "Selected step: \(stepSlider.index)"
    }
    
    //Mark: handle slider view
    func setupHorizontalSlider() {
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let value = sender.value
        print("Slider value: \(value)")
        desc.text = String(value)
    }
    
    //Mark: handle switch view
    func setupSwitchButton() {
        `switch`.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchValueChanged(_ sender: UISwitch) {
        let switchValue = sender.isOn
        if switchValue {
            desc.text = "The Switch is ON"
            setupProgressViewForLongTask()
        } else {
            setupProgressView()
            desc.text = "The Switch is OFF"
        }
    }
    
    //Mark: handle progress view
    func setupProgressView() {
        progress.setProgress(0.1, animated: true)
    }
    
    func setupProgressViewForLongTask() {
        //Inside your long-running task or operation
        let totalBytes: Float = 1000
        var downloadedBytes: Float = 0
        
        while downloadedBytes < totalBytes {
            // Simulate downloading a chunk of data
            let chunkSize: Float = 10
            downloadedBytes += chunkSize
            
            // Calculate progress and update the UIProgressView
            let totalProgress = downloadedBytes / totalBytes
            progress.setProgress(totalProgress, animated: true)
        }
    }
    
    func setupPickerView() {
        hours.append(contentsOf: ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"])
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
}

extension LatihanPickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return hours.count
        } else if component == 1 {
            return minutes.count
        } else {
            return ampm.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return hours[row]
        } else if component == 1 {
            return minutes[row]
        } else {
            return ampm[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedHour = hours[pickerView.selectedRow(inComponent: 0)]
        let selectedMinutes = minutes[pickerView.selectedRow(inComponent: 1)]
        let selectedAMPM = ampm[pickerView.selectedRow(inComponent: 2)]
        let selectedTime = "\(selectedHour):\(selectedMinutes) \(selectedAMPM)"
        
        print(selectedTime)
        desc.text = selectedTime
        
    }
}
