import UIKit
import Kingfisher
import RxSwift


class DetailStoryViewController: BaseBottomSheetController {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var uploadedImage: UIImageView!
    @IBOutlet weak var likePopUp: UIImageView!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentsCount: UILabel!
    @IBOutlet weak var createdAt: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    let dateFormatter = DateFormatter()
    let vm = DetailStoryViewModel()
    var storyID: String?
    var downloadTask: URLSessionDownloadTask!
    var detailStory: DetailStoryResponse? {
        didSet {
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCommentPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let storyID = storyID {
            vm.fetchDetailStory(param: storyID)
        }
        bindData()
    }
    
    func setup() {
        profileImage.layer.cornerRadius = 18
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        uploadedImage.addGestureRecognizer(doubleTapGesture)
        commentsCount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentLabelTap(_:))))
        likeBtn.setAnimateBounce()
        commentBtn.setAnimateBounce()
        shareBtn.setAnimateBounce()
    }
    
    func configure() {
        guard let validDetail = detailStory?.story else {return}
        navigationItem.title = "\(validDetail.name)'s Story"
        username.text = validDetail.name
        let url = URL(string: validDetail.photoURL)
        uploadedImage.kf.setImage(with: url, options: [
            .loadDiskFileSynchronously,
            .cacheOriginalImage,
            .transition(.fade(0.25)),
        ])
        likeBtn.setImage(validDetail.isLiked == true ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeBtn.tintColor = validDetail.isLiked == true ? .systemRed : .label
        likesCount.text = "\(validDetail.likesCount) Likes"
        likeBtn.isSelected = false
        let attributedString = NSAttributedString(string: "\(validDetail.name)  \(validDetail.description)")
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let range = NSRange(location: 0, length: validDetail.name.count)
        let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
        caption.attributedText = attributedText
        commentsCount.text = "\(validDetail.commentsCount) comments"
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        if let date = dateFormatter.date(from: validDetail.createdAt) {
            let timeAgo = date.convertDateToTimeAgo()
            createdAt.text = timeAgo
        }
        guard validDetail.lat != nil && validDetail.lon != nil else {return}
        if let lat = validDetail.lat, let lon = validDetail.lon {
            self.getLocationNameFromCoordinates(lat: lat, lon: lon) { name in
                if let locationName = name {
                    let attributedString = NSAttributedString(string: "\(validDetail.name)\n\(locationName)")
                    let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
                    let range = NSRange(location: validDetail.name.count + 1, length: locationName.count)
                    let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
                    self.username.attributedText = attributedText
                }
            }
        }
    }
    
    
    func bindData() {
        vm.detailStoryData.asObservable().subscribe(onNext: {[weak self] data in
            guard let self = self else { return }
            self.detailStory = data
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: {[weak self] state in
            guard let self = self else {return}
            switch state {
            case .notLoad, .loading:
                self.view.showAnimatedGradientSkeleton()
            case .failed, .finished:
                DispatchQueue.main.async {
                    self.view.hideSkeleton()
                }
            }
        }).disposed(by: bag)
    }
    
    @objc func onImageDoubleTap(_ sender: UITapGestureRecognizer) {
        guard self.likePopUp.isHidden == true else { return }
        self.likePopUp.addShadow()
        self.displayPopUp()
    }
    
    func displayPopUp() {
        self.likePopUp.isHidden = false
        if detailStory?.story.isLiked == false {
            self.addLike()
        }
        UIView.animate(withDuration: 0.8, delay: 0.0 , usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: [.curveEaseInOut], animations: {
            self.likePopUp.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1, delay: 0.2, options: [.curveEaseInOut], animations: {
                self.likePopUp.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
            }, completion: { _ in
                self.likePopUp.isHidden = true
            })
        })
    }
    
    func setupCommentPanel() {
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
    }
    
    func addLike() {
        var post = detailStory?.story
        if post!.isLiked {
            post?.isLiked = false
            post?.likesCount -= 1
            self.detailStory?.story = post!
        } else {
            post?.isLiked = true
            post?.likesCount += 1
            self.detailStory?.story = post!
        }
    }
    
    @IBAction func onLikeBtnTap() {
        addLike()
    }
    
    @IBAction func onCommentBtnTap() {
        present(floatingPanel, animated: true)
    }
    
    @IBAction func onShareBtnTap() {
        
    }
    
    @objc func onCommentLabelTap(_ sender: UITapGestureRecognizer) {
        present(floatingPanel, animated: true)
    }
    
    @IBAction func downloadImage() {
        guard let urlDownload = detailStory?.story.photoURL, let url = URL(string: urlDownload) else {
                return
            }

            // Create a URLSession with a delegate to track download progress
            let configuration = URLSessionConfiguration.default
            let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)

            // Create a download task
            downloadTask = session.downloadTask(with: url)
            downloadTask.resume()
        }
}

extension DetailStoryViewController: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        // The file has been downloaded successfully, and it's located at the 'location' URL.
        // You can move the file to your desired location or perform any other actions.
        
        print("Download finished: \(location)")
        
        // For example, copying the file to the Documents directory
        let documentsURL = try! FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destinationURL = documentsURL.appendingPathComponent("downloadedFile.zip")
        
        try? FileManager.default.moveItem(at: location, to: destinationURL)
        
        // Perform any additional actions you need with the downloaded file.
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        // This method is called periodically while the file is being downloaded.
        // You can use the progress information to update a progress bar, for example.
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("Download progress: \(progress * 100)%")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        // This method is called when the download task is completed (either successfully or with an error).
        if let error = error {
            print("Download failed with error: \(error.localizedDescription)")
        } else {
            print("Download completed successfully.")
        }
    }
}
