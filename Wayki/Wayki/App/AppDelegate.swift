

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .default
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.frame = UIScreen.main.bounds
        self.window?.rootViewController = UINavigationController(rootViewController: CenterC())
        self.window?.makeKeyAndVisible()
        ConfigureManager.configureLibrary()
        return true
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        ConfigureManager.handle3DTouchAction(type: shortcutItem.type)
    }

}


