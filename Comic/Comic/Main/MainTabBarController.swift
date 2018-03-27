//
//  MainTabBarController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/19.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        
        let homevc = HomeViewController(titles: ["推荐",
                                                 "VIP",
                                                 "订阅",
                                                 "排行"],
                                        vcs: [HomeRecommendViewController(),
                                              HomeVIPViewController(),
                                              HomeSubscribeViewController(),
                                              HomeRankViewController()],
                                        pageStyle: .navgationBarSegment)
        addChildViewController(homevc, title: "首页", image: "tab_home", selectedImage: "tab_home_S")
        
        addChildViewController(GateListViewController(), title: "分类", image: "tab_class", selectedImage: "tab_class_S")
        
        let bookvc = BookViewController(titles: ["收藏","书单","下载"], vcs: [UIViewController(),UIViewController(),UIViewController()], pageStyle: .navgationBarSegment)
        addChildViewController(bookvc, title: "书架", image: "tab_book", selectedImage: "tab_book_S")
        
        addChildViewController(MineViewController(), title: "我的", image: "tab_mine", selectedImage: "tab_mine_S")
        
    }

    func addChildViewController(_ childController: UIViewController, title: String, image: String, selectedImage: String) {
        childController.title = title
        childController.tabBarItem.title = nil
        childController.tabBarItem.image = UIImage(named: image)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named: selectedImage)?.withRenderingMode(.alwaysOriginal)
        childController.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        addChildViewController(BaseNavController(rootViewController: childController))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
