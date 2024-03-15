//
//  TabBarCoordinator.swift
//  TMDB
//
//  Created by Pavlo on 15.01.2024.
//

import UIKit

protocol TabCoordinatorProtocol: Coordinator {
    var tabBarController: UITabBarController { get set }
    
    func selectPage(_ page: TabBarPage)
    func setSelectedIndex(_ index: Int)
    func currentPage() -> TabBarPage?
}

final class TabCoordinator: NSObject, Coordinator {
    weak var finishDelegate: CoordinatorFinishDelegate?
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var tabBarController: UITabBarController
    var type: CoordinatorType { .tab }
    
    required init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let pages = TabBarPage.allCases.sorted(by: { $0.orderNumber < $1.orderNumber })
        let controllers: [UINavigationController] = pages.map({ getTabController($0) })
        prepareTabBarController(withTabControllers: controllers)
    }
    
    private func prepareTabBarController(withTabControllers tabControllers: [UIViewController]) {
        tabBarController.delegate = self
        tabBarController.setViewControllers(tabControllers, animated: false)
        tabBarController.selectedIndex = TabBarPage.genres.orderNumber
        tabBarController.tabBar.isTranslucent = true

        navigationController.viewControllers = [tabBarController]
    }
    
    private func getTabController(_ page: TabBarPage) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .always
        navigationController.setNavigationBarHidden(false, animated: false)
        navigationController.tabBarItem = UITabBarItem.init(title: page.title,
                                                            image: UIImage(systemName: page.image),
                                                            tag: page.orderNumber)
        
        switch page {
        case .genres:
            let genresCoordinator = GenresCoordinator(navigationController)
            genresCoordinator.finishDelegate = self
            genresCoordinator.start()
            childCoordinators.append(genresCoordinator)
        case .search:
            let searchCoordinator = SearchCoordinator(navigationController)
            searchCoordinator.finishDelegate = self
            searchCoordinator.start()
            childCoordinators.append(searchCoordinator)
        case .favorites:
            let favoritesCoordinator = FavoritesCoordinator(navigationController)
            favoritesCoordinator.finishDelegate = self
            favoritesCoordinator.start()
            childCoordinators.append(favoritesCoordinator)
        }
        
        return navigationController
    }
    
    private func currentPage() -> TabBarPage? {
        return TabBarPage.init(index: tabBarController.selectedIndex)
    }
    
    private func selectPage(_ page: TabBarPage) {
        tabBarController.selectedIndex = page.orderNumber
    }
    
    private func setSelectedIndex(_ index: Int) {
        guard let page = TabBarPage.init(index: index) else { return }
        tabBarController.selectedIndex = page.orderNumber
    }
}

// MARK: - CoordinatorFinishDelegate
extension TabCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        
        navigationController.viewControllers.removeAll()
        finish()
    }
}

// MARK: - UITabBarControllerDelegate
extension TabCoordinator: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        // Some implementation
    }
}
