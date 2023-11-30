import UIKit
import Kingfisher
import RxSwift


class DetailStoryViewController: BaseBottomSheetController {
    
    @IBOutlet private weak var profileImage: UIImageView!
    @IBOutlet private weak var username: UILabel!
    @IBOutlet private weak var uploadedImage: UIImageView!
    @IBOutlet private weak var likePopUp: UIImageView!
    @IBOutlet private weak var likeBtn: UIButton!
    @IBOutlet private weak var commentBtn: UIButton!
    @IBOutlet private weak var shareBtn: UIButton!
    @IBOutlet private weak var caption: UILabel!
    @IBOutlet private weak var likesCount: UILabel!
    @IBOutlet private weak var commentsCount: UILabel!
    @IBOutlet private weak var createdAt: UILabel!
    @IBOutlet private weak var downloadBtn: UIButton!
    
    private let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    private let vm = DetailStoryViewModel()
    internal var storyID: String?
    private var downloadTask: URLSessionDownloadTask!
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }
    private var detailStory: Story? {
        didSet {
            DispatchQueue.main.async {
                self.configure()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCommentPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let storyID = storyID {
            vm.fetchDetailStory(param: storyID)
        }
    }
    
    private func setupUI() {
        profileImage.layer.cornerRadius = 18
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(onImageDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        uploadedImage.addGestureRecognizer(doubleTapGesture)
        commentsCount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onCommentLabelTap(_:))))
        [likeBtn, commentBtn, shareBtn].forEach{ $0?.setAnimateBounce()}
        bindData()
    }
    
    private func configure() {
        guard let validDetail = detailStory else { return }
        navigationItem.title = "\(validDetail.name)'s Story"
        username.text = validDetail.name
        setupUploadedImage(validDetail)
        setupLikeButton(validDetail)
        setupCaption(validDetail)
        commentsCount.text = "\(validDetail.commentsCount) comments"
        setupCreatedAt(validDetail)
        guard validDetail.lat != nil, validDetail.lon != nil else { return }
        setupLocation(validDetail)
    }
    
    private func setupUploadedImage(_ data: Story) {
        uploadedImage.kf.setImage(with: URL(string: data.photoURL), options: [.loadDiskFileSynchronously, .cacheOriginalImage, .transition(.fade(0.25))])
    }
    
    private func setupLikeButton(_ data: Story) {
        likeBtn.setImage(data.isLiked ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"), for: .normal)
        likeBtn.tintColor = data.isLiked ? .systemRed : .label
        likesCount.text = "\(data.likesCount) Likes"
    }
    
    private func setupCaption(_ data: Story) {
        let attributedString = NSAttributedString(string: "\(data.name)  \(data.description)")
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)]
        let range = NSRange(location: 0, length: data.name.count)
        caption.attributedText = attributedString.applyingAttributes(attributes, toRange: range)
    }
    
    private func setupCreatedAt(_ data: Story) {
        if let date = dateFormatter.date(from: data.createdAt) {
            let timeAgo = date.convertDateToTimeAgo()
            createdAt.text = timeAgo
        }
    }
    
    private func setupLocation(_ data: Story) {
        guard let lat = data.lat, let lon = data.lon else { return }
        getLocationNameFromCoordinates(lat: lat, lon: lon) { [weak self] name in
            guard let self = self, let locationName = name else { return }
            let attributedString = NSAttributedString(string: "\(data.name)\n\(locationName)")
            let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14, weight: .regular)]
            let range = NSRange(location: data.name.count + 1, length: locationName.count)
            let attributedText = attributedString.applyingAttributes(attributes, toRange: range)
            self.username.attributedText = attributedText
        }
    }
    
    private func bindData() {
        vm.detailStoryData.asObservable().subscribe(onNext: { [weak self] data in
            guard let self = self else { return }
            self.detailStory = data?.story
        }).disposed(by: bag)
        
        vm.loadingState.asObservable().subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
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
    
    @objc private func onImageDoubleTap(_ sender: UITapGestureRecognizer) {
        guard self.likePopUp.isHidden == true else { return }
        self.likePopUp.addShadow()
        self.displayPopUp()
    }
    
    private func displayPopUp() {
        self.likePopUp.isHidden = false
        if detailStory?.isLiked == false {
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
    
    private func setupCommentPanel() {
        setupBottomSheet(contentVC: cvc, floatingPanelDelegate: self)
    }
    
    private func addLike() {
        var post = detailStory
        if post!.isLiked {
            post?.isLiked = false
            post?.likesCount -= 1
            self.detailStory? = post!
        } else {
            post?.isLiked = true
            post?.likesCount += 1
            self.detailStory? = post!
        }
    }
    
    @IBAction private func onLikeBtnTap() {
        addLike()
    }
    
    @IBAction private func onCommentBtnTap() {
        present(floatingPanel, animated: true)
    }
    
    @IBAction private func onShareBtnTap() {
        // Handle share button tap
    }
    
    @objc private func onCommentLabelTap(_ sender: UITapGestureRecognizer) {
        present(floatingPanel, animated: true)
    }
    
    @IBAction private func downloadImage() {
        guard let urlDownload = detailStory?.photoURL, let url = URL(string: urlDownload) else { return }
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
        
        downloadTask = session.downloadTask(with: url)
        downloadTask.resume()
    }
}

extension DetailStoryViewController: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Download finished: \(location)")
        
        let documentsURL = try! FileManager.default.url(for: .downloadsDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let destinationURL = documentsURL.appendingPathComponent("downloadedFile.zip")
        
        try? FileManager.default.moveItem(at: location, to: destinationURL)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print("Download progress: \(progress * 100)%")
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Download failed with error: \(error.localizedDescription)")
        } else {
            print("Download completed successfully.")
        }
    }
}
