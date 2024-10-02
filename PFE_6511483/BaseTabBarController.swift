import UIKit

class BaseTabController: UITabBarController {

    

    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedIndex = 0
        tabBar.backgroundColor = .white
        tabBar.isTranslucent = false
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
            
        
        let movieVC = MovieViewController()
        movieVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "movieclapper.fill"), selectedImage: nil)
            
            
        let cinemaVC = CinemaViewController()
        cinemaVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "building.fill" ), selectedImage: nil)
            
        
        
            let movieNavigation = UINavigationController(rootViewController: movieVC )
            let cinemaNavigation = UINavigationController(rootViewController: cinemaVC )
         

            
            viewControllers = [movieNavigation,cinemaNavigation]
            
        }
    
    


}
