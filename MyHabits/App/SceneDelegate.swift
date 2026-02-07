
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func createFirstController() -> UINavigationController {
        let habitsVC = HabitsViewController()
        let fvc = UINavigationController(rootViewController: habitsVC)
        fvc.tabBarItem = UITabBarItem(title: "Привычки", image: UIImage(systemName: "rectangle.grid.1x2.fill"), tag: 0)
        return fvc
    }
    func createSecondController() -> UINavigationController {
        let infoVC = InfoViewController()
        let lvc = UINavigationController(rootViewController: infoVC)
        lvc.tabBarItem = UITabBarItem(title: "Информация", image: UIImage(systemName: "info.circle.fill"), tag: 1)
        return lvc
    }
    
    func createTabBar() -> UITabBarController {
        let tabBar = UITabBarController()
        tabBar.viewControllers = [createFirstController(), createSecondController()]
        let appearance = UITabBarAppearance()
            appearance.configureWithDefaultBackground()
            tabBar.tabBar.standardAppearance = appearance
            if #available(iOS 15.0, *) {
                tabBar.tabBar.scrollEdgeAppearance = appearance
            }
        tabBar.tabBar.tintColor = UIColor(
            red: 161/255,
            green: 22/255,
            blue: 204/255,
            alpha: 1.0)
        
        return tabBar
    }
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let winScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: winScene)
        window.rootViewController = createTabBar()
        window.makeKeyAndVisible()
        
        self.window = window
        
        let navAppearance = UINavigationBarAppearance()
        navAppearance.configureWithDefaultBackground()
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
    }
}

