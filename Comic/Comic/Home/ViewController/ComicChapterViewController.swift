//
//  ComicChapterViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/26.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class ComicChapterViewController: BaseViewController {

    fileprivate var isPositive: Bool = true
    
    var detailStatic: DetailStaticModel?
    var detailRealtime: DetailRealtimeModel?
    
    weak var delegate: UComicViewWillEndDraggingDelegate?
    
    fileprivate lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 10
        layout.itemSize = CGSize(width: floor((screenWidth - 30) / 2), height: 40)
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = UIColor.white
        cw.delegate = self
        cw.dataSource = self
        cw.alwaysBounceVertical = true
        cw.register(supplementaryViewType: ComicChapterHead.self, ofKind: UICollectionElementKindSectionHeader)
        cw.register(cellType: ComicChapterCell.self)
        return cw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {$0.edges.equalTo(self.view.usnp.edges) }
    }

}

extension ComicChapterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, ComicChapterHeadDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailStatic?.chapter_list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: screenWidth, height: 44)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let head = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, for: indexPath, viewType: ComicChapterHead.self)
        head.model = detailStatic
        head.delegate = self
        return head
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ComicChapterCell.self)
        if isPositive {
            cell.chapterStatic = detailStatic?.chapter_list?[indexPath.row]
        } else {
            cell.chapterStatic = detailStatic?.chapter_list?.reversed()[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = isPositive ? indexPath.row : ((detailStatic?.chapter_list?.count)! - indexPath.row - 1)
        let vc = ComicReadViewController(detailStatic: detailStatic, selectIndex: index)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func comicchapterHead(butoon: UIButton) {
        if self.isPositive == true {
            self.isPositive = false
            butoon.setTitle("正序", for: .normal)
        } else {
            self.isPositive = true
            butoon.setTitle("倒序", for: .normal)
        }
        self.collectionView.reloadData()
    }
   
    
}

