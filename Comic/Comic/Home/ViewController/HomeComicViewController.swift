//
//  HomeComicViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/26.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

protocol UComicViewWillEndDraggingDelegate: class {
    func comicWillEndDragging(_ scrollView: UIScrollView)
}

class HomeComicViewController: BaseViewController {

    fileprivate var comicid: Int = 0
    fileprivate var detailStatic: DetailStaticModel?
    fileprivate var detailRealtime: DetailRealtimeModel?
    
    fileprivate lazy var mainScrollView: UIScrollView = {
        let sw = UIScrollView()
        sw.delegate = self
        return sw
    }()
    
    fileprivate lazy var navigationBarY: CGFloat = {
        return navigationController?.navigationBar.frame.maxY ?? 0
    }()
    
    fileprivate lazy var headView: HomeComicHead = {
        return HomeComicHead(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: navigationBarY + 150))
    }()
    
    fileprivate lazy var detailVC: ComicDetailViewController = {
        let dc = ComicDetailViewController()
        dc.delegate = self
        return dc
    }()
    
    fileprivate lazy var chapterVC: ComicChapterViewController = {
        let dc = ComicChapterViewController()
        dc.delegate = self
        return dc
    }()
    
    fileprivate lazy var commentVC: ComicCommentViewController = {
        let cc = ComicCommentViewController()
        cc.delegate = self
        return cc
    }()
    
    fileprivate lazy var pageVC: MainPageViewController = {
        return MainPageViewController(titles: ["详情", "目录", "评论"],
                                   vcs: [detailVC, chapterVC, commentVC],
                                   pageStyle: .topTabBar)
    }()
    
    convenience init(comicid: Int) {
        self.init()
        self.comicid = comicid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        loadData()
    }
    
    fileprivate func loadData() {
        
        let grpup = DispatchGroup()
        grpup.enter()
        
        ApiLoadingProvider.request(ComicApi.detailStatic(comicid: comicid), model: DetailStaticModel.self) { (renturnData) in
            self.detailStatic = renturnData
            self.headView.detailStatic = renturnData?.comic
            self.detailVC.detailStatic = renturnData
            self.chapterVC.detailStatic = renturnData
            ApiProvider.request(ComicApi.commentList(object_id: self.detailStatic?.comic?.comic_id ?? 0,
                                                     thread_id: self.detailStatic?.comic?.thread_id ?? 0,
                                                     page: -1), model: CommentListModel.self, completion: { (returnData) in
                                                        self.commentVC.commentList = returnData
                                                        grpup.leave()
            })
        }
        
        grpup.enter()
        ApiProvider.request(ComicApi.detailRealtime(comicid: comicid), model: DetailRealtimeModel.self) { (renturnData) in
            self.headView.detailRealtime = renturnData?.comic
            self.detailVC.detailRealtime = renturnData
            self.chapterVC.detailRealtime = renturnData
           grpup.leave()
        }
        
        grpup.enter()
        ApiProvider.request(ComicApi.guessLike, model: GuessLikeModel.self) { (renturnData) in
            self.detailVC.guessLike = renturnData
            grpup.leave()
        }
        
        grpup.notify(queue: DispatchQueue.main) {
            self.detailVC.reloadData()
            self.chapterVC.reloadData()
            self.commentVC.reloadData()
        }
        
    }
    
    
    override func configUI() {
        
        print("adasd+",navigationController?.navigationBar.frame.maxY ?? 0)
        
        view.addSubview(mainScrollView)
        mainScrollView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges).priority(.low)
            $0.top.equalToSuperview()
        }
        
        let contentView = UIView()
        mainScrollView.addSubview(contentView)
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.equalToSuperview().offset(-navigationBarY)
        }
        
        addChildViewController(pageVC)
        contentView.addSubview(pageVC.view)
        pageVC.view.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        mainScrollView.parallaxHeader.view = headView
        mainScrollView.parallaxHeader.height = navigationBarY + 150
        mainScrollView.parallaxHeader.minimumHeight = navigationBarY
        mainScrollView.parallaxHeader.mode = .fill
    }
    
    override func configNavigation() {
        super.configNavigation()
        navigationController?.barStyle(style: .clear)
        mainScrollView.contentOffset = CGPoint(x: 0, y: -mainScrollView.parallaxHeader.height)
    }
    
    
}

extension HomeComicViewController: UIScrollViewDelegate,UComicViewWillEndDraggingDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -scrollView.parallaxHeader.minimumHeight {
            navigationController?.barStyle(style: .theme)
            navigationItem.title = detailStatic?.comic?.name
        } else {
             navigationController?.barStyle(style: .clear)
            navigationItem.title = ""
        }
    }
    
    func comicWillEndDragging(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.minimumHeight),
                                            animated: true)
        } else if scrollView.contentOffset.y < 0 {
            mainScrollView.setContentOffset(CGPoint(x: 0,
                                                    y: -self.mainScrollView.parallaxHeader.height),
                                            animated: true)
        }
    }
}
