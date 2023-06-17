//
//  tab.swift
//  travel2
//
//  Created by WuShangJung on 2023/6/17.
//

import UIKit

class tab: UITabBarController {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            if let selectedIndex = tabBar.items?.firstIndex(of: item) {
                if let selectedNavController = viewControllers?[selectedIndex] as? UINavigationController {
                    if let selectedViewController = selectedNavController.topViewController as? CollectionTableViewController {
                        selectedViewController.viewDidLoad()
                    }
                }
            }
        }

}
