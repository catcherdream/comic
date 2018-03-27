//
//  HomeUpdateViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/23.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class HomeUpdateViewController: BaseViewController {
    
    fileprivate var argCon: Int = 0
    fileprivate var argName: String?
    fileprivate var argValue: Int = 0
    fileprivate var page: Int = 1
    
    fileprivate var comicList = [ComicModel]()
    fileprivate var spinnerName: String = ""
    
    fileprivate lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        tw.tableFooterView = UIView()
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: HomeUpdateCell.self)
        return tw
    }()
    
    convenience init(argCon: Int = 0, argName: String?, argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiLoadingProvider.request(ComicApi.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: 1), model: ComicListModel.self) { (returnData) in
            
            self.comicList = returnData?.comics ?? []
            guard let defaultParameters = returnData?.defaultParameters else { return }
            self.argCon = defaultParameters.defaultArgCon
            guard let defaultConTagType = defaultParameters.defaultConTagType else { return }
            self.spinnerName = defaultConTagType
            self.tableView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }
}

extension HomeUpdateViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HomeUpdateCell.self)
        cell.model = comicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
}



