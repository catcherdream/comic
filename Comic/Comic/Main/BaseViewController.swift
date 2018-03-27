//
//  BaseViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/19.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.background
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        configUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        configNavigation()
    }
    
    func configUI() {
        
    }
    
    func configNavigation() {
        guard let nav = navigationController else {
            return
        }
        //当前控制齐
        if nav.visibleViewController == self {
            nav.barStyle(style: .theme)
            nav.setNavigationBarHidden(false, animated: true)
            if nav.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "nav_back_white")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(goBack))
            }
        }
    }
    
    @objc func goBack() {
         navigationController?.popViewController(animated: true)
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
