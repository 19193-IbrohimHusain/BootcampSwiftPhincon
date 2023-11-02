import UIKit

class MainTabBarViewController: UITabBarController {
    
    let movie = UINavigationController(rootViewController: MovieViewController())
    let tv = UINavigationController(rootViewController: TvSeriesViewController())

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureTabBarItem()
    }
    

    func configureTabBar() {
        setViewControllers([movie, tv], animated: true)
    }
    
    func configureTabBarItem() {
        movie.tabBarItem = UITabBarItem(title: "Movie", image: UIImage(systemName: "film.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), tag: 0)
        tv.tabBarItem = UITabBarItem(title: "TV Series", image: UIImage(systemName: "tv.fill", withConfiguration: UIImage.SymbolConfiguration(scale: .medium)), tag: 1)
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        self.tabBar.unselectedItemTintColor = UIColor.white
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.yellow], for: .selected)
        UITabBar.appearance().tintColor = UIColor.yellow
        self.tabBar.backgroundColor = UIColor.black
    }

}
