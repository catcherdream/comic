//
//  ComicCommentViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/26.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class ComicCommentViewController: BaseViewController {

    var detailStatic: DetailStaticModel?
    var commentList: CommentListModel? {
        didSet {
            guard let commentList = commentList?.commentList else {
                return
            }
            let viewModelArray = commentList.flatMap { (comment) -> ComicCommentCellModel? in
                return ComicCommentCellModel(model: comment)
            }
            listArray.append(contentsOf: viewModelArray)
        }
    }
    
    private var listArray = [ComicCommentCellModel]()
    
    weak var delegate: UComicViewWillEndDraggingDelegate?
    
    private lazy var tableView: UITableView = {
        let tw = UITableView(frame: .zero, style: .plain)
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: ComicCommentCell.self)
        return tw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalTo(self.view.usnp.edges)
        }
    }

}

extension ComicCommentViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.comicWillEndDragging(scrollView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return listArray[indexPath.row].height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: ComicCommentCell.self)
        cell.viewModel = listArray[indexPath.row]
        return cell
    }
}

