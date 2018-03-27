//
//  GateListViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/19.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit
import SnapKit

class GateListViewController: BaseViewController {
    
    fileprivate var topList = [TopModel]()
    fileprivate var rankList = [RankingModel]()
    
    fileprivate lazy var searchButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.frame = CGRect(x: 0, y: 0, width: screenWidth - 20, height: 30)
        btn.layer.cornerRadius = 15
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5)
        return btn
    }()
    
    fileprivate lazy var collectView: UICollectionView = {
        let lt = UICollectionViewFlowLayout()
        let clview = UICollectionView(frame: .zero, collectionViewLayout: lt)
        clview.backgroundColor = UIColor.white
        clview.dataSource = self
        clview.delegate = self
        clview.alwaysBounceVertical = true
        clview.register(cellType: TopCollectionCell.self)
        clview.register(cellType: RankCollectionCell.self)
        return clview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        ApiLoadingProvider.request(ComicApi.cateList, model: CateListModel.self) { (returnData) in
            self.searchButton .setTitle(returnData?.recommendSearch ?? "", for: .normal)
            self.topList = returnData?.topList ?? []
            self.rankList = returnData?.rankingList ?? []
            self.collectView.reloadData()
        }
        
    }

    override func configUI() {
        view.addSubview(collectView)
        collectView.snp.makeConstraints{$0.edges.equalTo(self.view.usnp.edges)}
    }
    
    override func configNavigation() {
        super.configNavigation()
        navigationItem.titleView = searchButton
    }
}

extension GateListViewController: UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return topList.takeMax(3).count
        }
        return rankList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.section == 0) {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: TopCollectionCell.self)
            cell.model = topList[indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: RankCollectionCell.self)
        cell.model = rankList[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 0, 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 40.0) / 3.0)
        return CGSize(width: width, height: (indexPath.section == 0 ? 55 : (width * 0.75 + 30)))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let model = topList[indexPath.row]
            var titles: [String] = []
            var vcs: [UIViewController] = []
            for tab in model.extra?.tabList ?? [] {
                guard let tabTitle = tab.tabTitle else { continue }
                titles.append(tabTitle)
                vcs.append(GateInfoListViewController(argCon: tab.argCon,
                                                    argName: tab.argName,
                                                    argValue: tab.argValue))
            }
            let vc = MainPageViewController(titles: titles, vcs: vcs, pageStyle: .topTabBar)
            vc.title = model.sortName
            navigationController?.pushViewController(vc, animated: true)
        }
        
        if(indexPath.section == 1) {
            let model = rankList[indexPath.row]
            let vc = GateInfoListViewController(argCon: model.argCon, argName: model.argName, argValue: model.argValue)
            vc.title = model.sortName
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    
    
    
}

