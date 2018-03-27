//
//  HomeRankViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/23.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class HomeRankViewController: BaseViewController {

     fileprivate var rankList = [RankingModel]()
    
    fileprivate lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        tableview.separatorStyle = .none
        tableview.delegate = self
        tableview.dataSource = self
        tableview.register(cellType: HomeRankCell.self)
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiLoadingProvider.request(ComicApi.rankList, model: RankinglistModel.self) { (returnData) in
            self.rankList = returnData?.rankinglist ?? []
            self.tableView.reloadData()
        }
        
    }

    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
           $0.edges.equalTo(self.view.usnp.edges)
        }
    }
    
}

extension HomeRankViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return rankList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: HomeRankCell.self)
        cell.model = rankList[indexPath.section]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = rankList[indexPath.section]
        let vc = GateInfoListViewController(argCon: model.argCon,
                                          argName: model.argName,
                                          argValue: model.argValue)
        vc.title = "\(model.title!)榜"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return screenWidth * 0.4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
}
