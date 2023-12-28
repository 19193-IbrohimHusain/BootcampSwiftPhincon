import UIKit

class TabBarViewController:  UITabBarController, UITabBarControllerDelegate {
    // MARK: - Variables
    private let home = UINavigationController(rootViewController: StoryViewController())
    private let map = UINavigationController(rootViewController: MapViewController())
    private var addStory: AddStoryViewController!
    private let store =  UINavigationController(rootViewController: StoreViewController())
    private let profile =  UINavigationController(rootViewController: ProfileViewController())
    
    // MARK: - Lifecycles
    override func viewDidLoad(){
        super.viewDidLoad()
        
        configureTabBar()
        configureTabBarItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    // MARK: - Functions
    private func hideNavigationBar() {
        self.navigationController?.isToolbarHidden = true
        self.navigationController?.isNavigationBarHidden = true
    }

    private func configureTabBar() {
        self.delegate = self
        addStory = AddStoryViewController()
        viewControllers = [home, map, addStory, store, profile]
    }
    
    private func configureTabBarItem() {
        home.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        home.tabBarItem.imageInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        map.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "location"), selectedImage: UIImage(systemName: "location.fill"))
        addStory.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: UIImage(systemName: "plus.app.fill"))
        store.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bag"), selectedImage: UIImage(systemName: "bag.fill"))
        profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.label
        self.tabBar.backgroundColor = UIColor.systemBackground
    }
    
    //MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.isKind(of: AddStoryViewController.self) {
            let vc =  AddStoryViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
}
