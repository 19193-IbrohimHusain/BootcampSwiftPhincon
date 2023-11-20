import UIKit

class TabBarViewController:  UITabBarController, UITabBarControllerDelegate {
    
    var home: StoryViewController!
    var map: MapViewController!
    var addStory: AddStoryViewController!
    var film: FolderViewController!
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
        film = FolderViewController()
        profile = ProfileViewController()
        navigationItem.backButtonTitle = ""
        viewControllers = [home, map, addStory, film, profile]
        
    }
    
    func configureTabBarItem() {
        home.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house"), selectedImage: UIImage(systemName: "house.fill"))
        map.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "location"), selectedImage: UIImage(systemName: "location.fill"))
        addStory.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: UIImage(systemName: "plus.app.fill"))
        film.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "film"), selectedImage: UIImage(systemName: "film.fill"))
        profile.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person.crop.circle"), selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        
        self.tabBar.unselectedItemTintColor = UIColor.gray
        self.tabBar.tintColor = UIColor.black
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
