//
//  HomeViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/23.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class HomeViewController: MainPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configNavigation() {
        super.configNavigation()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(selectAction))
    }

    @objc private func selectAction() {
        let vc = HomeSearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
