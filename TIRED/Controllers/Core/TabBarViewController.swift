//
//  TabbarController.swift
//  Sportify
//
//  Created by Apple on 30/04/2023.
//


import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let Vc1 = HomeViewController()
        let Vc2 = SerachViewController()
        let Vc3 = LibaryViewController()
        Vc1.navigationItem.largeTitleDisplayMode = .always
        Vc2.navigationItem.largeTitleDisplayMode = .always
        Vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: Vc1)
        let nav2 = UINavigationController(rootViewController: Vc2)
        let nav3 = UINavigationController(rootViewController: Vc3)
        
        nav1.navigationBar.tintColor = .label
        nav2.navigationBar.tintColor = .label
        nav3.navigationBar.tintColor = .label
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName:"magnifyingglass"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Library", image: UIImage(systemName: "music.note.list"), tag: 1)
        
        
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        setViewControllers([nav1,nav2,nav3], animated: false)
      
        // Do any additional setup after loading the view.
    }


}

