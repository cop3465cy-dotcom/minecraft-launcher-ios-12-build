import UIKit

class RootTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        let items: [(UIViewController, String, String)] = [(HomeViewController(), "Home", "house.fill"), (LibraryViewController(), "Library", "square.grid.2x2.fill"), (PacksViewController(), "Packs", "cube.box.fill"), (DownloadsViewController(), "Downloads", "arrow.down.circle.fill"), (SettingsViewController(), "Settings", "gear")]
        viewControllers = items.map { vc, title, _ in let nav = UINavigationController(rootViewController: vc); nav.tabBarItem = UITabBarItem(title: title, image: nil, selectedImage: nil); return nav }
        tabBar.tintColor = Palette.green; applyTheme()
        NotificationCenter.default.addObserver(self, selector: #selector(applyTheme), name: .themeDidChange, object: nil)
    }
    @objc private func applyTheme() { view.backgroundColor = Palette.background; tabBar.barTintColor = Palette.card; tabBar.isTranslucent = true; UINavigationBar.appearance().barTintColor = Palette.card; UINavigationBar.appearance().tintColor = Palette.green; UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: Palette.text]; viewControllers?.forEach { $0.navigationController?.navigationBar.barTintColor = Palette.card; $0.navigationController?.navigationBar.tintColor = Palette.green; $0.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: Palette.text] } }
}
