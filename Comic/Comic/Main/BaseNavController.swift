//
//  MainNavigationController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/19.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

enum UNavigationBarStyle {
    case theme
    case clear
    case white
}

class BaseNavController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension UINavigationController {
    
    func barStyle(style: UNavigationBarStyle) {
        switch style {
        case .theme:
            navigationBar.barStyle = .black //黑底白字
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        case .white:
            navigationBar.barStyle = .default //白底黑字
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = nil
        }
        
    }
    
}
