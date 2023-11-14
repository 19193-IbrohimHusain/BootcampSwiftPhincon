import UIKit

class TabBarViewController:  UITabBarController, UITabBarControllerDelegate {
    
    var home: StoryViewController!
    var map: MapViewController!
    var addStory: AddStoryViewController!
    var folder: FolderViewController!
    var profile: ProfileViewController!

    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        configureTabBar()
        configureTabBarItem()
    }
    
    func configureTabBar() {
        home = StoryViewController()
        map = MapViewController()
        addStory = AddStoryViewController()
        folder = FolderViewController()
        profile = ProfileViewController()
        navigationItem.backButtonTitle = ""
        viewControllers = [home, map, addStory, folder, profile]
    }
    
    func configureTabBarItem() {
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        map.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 1)
        addStory.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.app"), tag: 2)
        folder.tabBarItem = UITabBarItem(title: "Folder", image: UIImage(systemName: "folder"), tag: 3)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.tabBar.unselectedItemTintColor = UIColor.gray
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        UITabBar.appearance().tintColor = UIColor.black
        self.tabBar.backgroundColor = UIColor.white
    }
    //MARK: UITabbar Delegate
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
