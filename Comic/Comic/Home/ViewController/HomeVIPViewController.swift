//
//  HomeVIPViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/23.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class HomeVIPViewController: BaseViewController {

    fileprivate var vipList = [ComicListModel]()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: HomeComicCell.self)
        cw.register(supplementaryViewType: HomeComicHeadView.self, ofKind: UICollectionElementKindSectionHeader)
        cw.register(supplementaryViewType: HomeComicFootView.self, ofKind: UICollectionElementKindSectionFooter)
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiLoadingProvider.request(ComicApi.vipList, model: VipListModel.self) { (returnData) in
            self.vipList = returnData?.newVipList ?? []
            self.collectionView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{ $0.edges.equalTo(self.view.usnp.edges) }
    }

}

extension HomeVIPViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource,HomeComicHeadViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return vipList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = vipList[section]
        return comicList.comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeComicCell.self)
        cell.style = .withTitle
        let comicList = vipList[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath, viewType: HomeComicHeadView.self)
            head.delegate = self
            head.model = vipList[indexPath.section]
            return head
        } else {
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: indexPath, viewType: HomeComicFootView.self)
            return foot
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = vipList[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return vipList.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor(Double(screenWidth - 10.0) / 3.0)//如果参数是小数  则求最大的整数但不大于本身.
        return CGSize(width: width, height: 240)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = vipList[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else { return }
        let vc = HomeComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func comicCHead(model: ComicListModel) {
        print(model.itemTitle!)
        let vc = GateInfoListViewController(argCon:model.argCon, argName:model.argName, argValue:model.argValue)
        vc.title = model.itemTitle
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


