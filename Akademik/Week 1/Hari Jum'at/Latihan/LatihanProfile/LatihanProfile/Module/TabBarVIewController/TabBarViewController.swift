import UIKit

class CustomTabBarController:  UITabBarController, UITabBarControllerDelegate {
    
    var home: StoryViewController!
    var addStory: AddStoryViewController!
    var profile: ProfileViewController!

    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        configureTabBar()
        configureTabBarItem()
    }
    
    func configureTabBar() {
        home = StoryViewController()
        addStory = AddStoryViewController()
        profile = ProfileViewController()
        viewControllers = [home, addStory, profile]
    }
    
    func configureTabBarItem() {
        home.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house.fill"), tag: 0)
        addStory.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus.app.fill"), tag: 1)
        profile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.fill"), tag: 2)
        
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
