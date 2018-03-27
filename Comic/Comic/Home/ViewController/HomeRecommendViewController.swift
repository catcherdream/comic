//
//  HomeRecommendViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/23.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit
import LLCycleScrollView

class HomeRecommendViewController: BaseViewController {

    fileprivate var galleryItems = [GalleryItemModel]()
    fileprivate var TextItems = [TextItemModel]()
    fileprivate var comicLists = [ComicListModel]()
    
    fileprivate lazy var bannerView: LLCycleScrollView = {
        let bw = LLCycleScrollView()
        bw.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        bw.autoScrollTimeInterval = 6
        bw.placeHolderImage = UIImage(named: "normal_placeholder")
        bw.coverImage = UIImage()
        bw.pageControlPosition = .right
        bw.pageControlBottom = 20
        bw.titleBackgroundColor = UIColor.clear
        bw.lldidSelectItemAtIndex = didSelectBanner(index:)
        return bw
    }()
    
    fileprivate lazy var collectionView: UICollectionView = {
        let lt = UCollectionViewSectionBackgroundLayout()
        lt.minimumInteritemSpacing = 5
        lt.minimumLineSpacing = 10
        let cw = UICollectionView(frame: CGRect.zero, collectionViewLayout: lt)
        cw.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        cw.contentInset = UIEdgeInsetsMake(screenWidth * 0.467, 0, 0, 0)
        cw.scrollIndicatorInsets = cw.contentInset
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(cellType: HomeComicCell.self)
        cw.register(cellType: HomeBoardCCell.self)
        cw.register(supplementaryViewType: HomeComicHeadView.self, ofKind: UICollectionElementKindSectionHeader)
        cw.register(supplementaryViewType: HomeComicFootView.self, ofKind: UICollectionElementKindSectionFooter)
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ApiLoadingProvider.request(ComicApi.boutiqueList(sexType: 1), model: BoutiqueListModel.self) { (returnData) in
            self.galleryItems = returnData?.galleryItems ?? []
            self.TextItems = returnData?.textItems ?? []
            self.comicLists = returnData?.comicLists ?? []
            self.bannerView.imagePaths = self.galleryItems.map { $0.cover! }
            self.collectionView.reloadData()
        }
        
    }
    

    override func configUI() {
        
        view.addSubview(collectionView)
        view.addSubview(bannerView)
        
        collectionView.snp.makeConstraints{
            $0.edges.equalTo(self.view.usnp.edges)
        }
        
        bannerView.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.height.equalTo(collectionView.contentInset.top)
        }
    }
    
    fileprivate func didSelectBanner(index: NSInteger) {
        let item = galleryItems[index]
        if item.linkType == 2 {
            guard let url = item.ext?.flatMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
            let vc = MainWebViewController(url: url)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

extension HomeRecommendViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout, UICollectionViewDataSource,HomeComicHeadViewDelegate{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return comicLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let comicList = comicLists[section]
        return comicList.comics?.takeMax(4).count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeBoardCCell.self)
            cell.model = comicList.comics?[indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: HomeComicCell.self)
        if comicList.comicType == .thematic {
            cell.style = .none
        } else {
            cell.style = .withTitieAndDesc
        }
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath, viewType: HomeComicHeadView.self)
            head.delegate = self
            head.model = comicLists[indexPath.section]
            head.moreButton.isHidden = false
            return head
        } else {
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, for: indexPath, viewType: HomeComicFootView.self)
            return foot
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = comicLists[section]
        return comicList.itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return comicLists.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comicList = comicLists[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5.0) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let comicList = comicLists[indexPath.section]
            guard let item = comicList.comics?[indexPath.row] else { return }
            
            if comicList.comicType == .billboard {
                let vc = GateInfoListViewController(argCon: item.argCon,
                                                    argName: item.argName,
                                                    argValue: item.argValue)
                vc.title = item.name
                navigationController?.pushViewController(vc, animated: true)
            } else {
                if item.linkType == 2 {
                    guard let url = item.ext?.flatMap({ return $0.key == "url" ? $0.val : nil }).joined() else { return }
                    let vc = MainWebViewController(url: url)
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = HomeComicViewController(comicid: item.comicId)
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }
    
    func comicCHead(model: ComicListModel) {
        print(model.comicType)
        if model.comicType == .thematic {
            let vc = MainPageViewController(titles: ["推荐","VIP"],
                                            vcs: [HomeRecommendViewController(),
                                                  HomeVIPViewController()],
                                            pageStyle: .navgationBarSegment)
            navigationController?.pushViewController(vc, animated: true)
        } else if model.comicType == .animation {
            let vc = MainWebViewController(url: "http://m.u17.com/wap/cartoon/list")
            vc.title = "动画"
            navigationController?.pushViewController(vc, animated: true)
        } else if model.comicType == .update {
            let vc = HomeUpdateViewController(argCon: model.argCon,
                                               argName: model.argName,
                                               argValue: model.argValue)
            vc.title = model.itemTitle
            navigationController?.pushViewController(vc, animated: true)
        } else {
            let vc = GateInfoListViewController(argCon:model.argCon, argName:model.argName, argValue:model.argValue)
            vc.title = model.itemTitle
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            bannerView.snp.updateConstraints{
                $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top)))
            }
        }
    }
    
}


