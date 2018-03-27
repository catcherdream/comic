//
//  HomeSearchViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/23.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit
import Moya

class HomeSearchViewController: BaseViewController {

    private var currentRequest: Cancellable?
    
    private var hotItems: [SearchItemModel]?
    
    private var relative: [SearchItemModel]?
    
    private var comics: [ComicModel]?
    
    fileprivate lazy var searchHistory: [String]! = {
        return UserDefaults.standard.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
    }()
    
    fileprivate lazy var searchBar: UITextField = {
        let sr = UITextField()
        sr.backgroundColor = UIColor.white
        sr.textColor = UIColor.gray
        sr.tintColor = UIColor.darkGray
        sr.font = UIFont.systemFont(ofSize: 15)
        sr.placeholder = "输入漫画名称/作者"
        sr.layer.cornerRadius = 15
        sr.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        sr.leftViewMode = .always
        sr.clearsOnBeginEditing = true
        sr.clearButtonMode = .whileEditing
        sr.returnKeyType = .search
        sr.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(textFiledTextDidChange(noti:)), name: .UITextFieldTextDidChange, object: sr)
        return sr
    }()
    
    fileprivate lazy var historyTableView: UITableView = {
        let tw = UITableView(frame: CGRect.zero, style: .grouped)
        tw.delegate = self
        tw.dataSource = self
        tw.register(cellType: BaseTableViewCell.self)
        return tw
    }()
    
    fileprivate lazy var searchTableView: UITableView = {
        let sw = UITableView(frame: CGRect.zero, style: .grouped)
        sw.delegate = self
        sw.dataSource = self
        sw.isHidden = true
        sw.register(cellType: BaseTableViewCell.self)
        return sw
    }()
    
    fileprivate lazy var resultTableView: UITableView = {
        let rw = UITableView(frame: CGRect.zero, style: .grouped)
        rw.delegate = self
        rw.dataSource = self
        rw.isHidden = true
        rw.register(cellType: SeaichComicCell.self)
        return rw
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadHistory()
    }
    
    fileprivate func loadHistory() {
        ApiLoadingProvider.request(ComicApi.searchHot, model: HotItemsModel.self) { (returnData) in
            self.hotItems = returnData?.hotItems ?? []
            self.historyTableView.reloadData()
        }
    }
    
    override func configUI() {
        view.addSubview(historyTableView)
        historyTableView.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }

        view.addSubview(searchTableView)
        searchTableView.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }

        view.addSubview(resultTableView)
        resultTableView.snp.makeConstraints { $0.edges.equalTo(self.view.usnp.edges) }
    }
    
    override func configNavigation() {
        super.configNavigation()
        searchBar.frame = CGRect(x: 0, y: 0, width: screenWidth - 50, height: 30)
        navigationItem.titleView = searchBar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: nil,
                                                           style: .plain,
                                                           target: nil,
                                                           action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action:  #selector(cancelAction))
    }
    
    @objc private func cancelAction() {
        searchBar.resignFirstResponder()
        navigationController?.popViewController(animated: true)
    }
    
    private func searchRelative(_ text: String) {
        print("..........",text)
        if text.count > 0 {
            searchTableView.isHidden = false
            historyTableView.isHidden = true
            
            ApiLoadingProvider.request(ComicApi.searchHot, model: HotItemsModel.self) { (returnData) in
                self.relative = returnData?.hotItems ?? []
                self.searchTableView.reloadData()
            }
        }else {
            searchTableView.isHidden = true
            historyTableView.isHidden = false
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func searchResult(_ text: String)  {
        historyTableView.isHidden = true
        searchTableView.isHidden = true
        resultTableView.isHidden = false
        ApiLoadingProvider.request(ComicApi.searchResult(argCon: 0, q: text), model: SearchResultModel.self) { (returnData) in
            self.comics = returnData?.comics
             self.resultTableView.reloadData()
        }
        let defaults = UserDefaults.standard
        var histoary = defaults.value(forKey: String.searchHistoryKey) as? [String] ?? [String]()
        histoary.removeAll([text])
        histoary.insertFirst(text)
        
        searchHistory = histoary
        historyTableView.reloadData()
        
        defaults.set(searchHistory, forKey: String.searchHistoryKey)
        defaults.synchronize()
    
    }
    
}

extension HomeSearchViewController: UITextFieldDelegate {
    
    @objc func textFiledTextDidChange(noti: Notification) {
        guard let textField = noti.object as? UITextField,
            let text = textField.text else { return }
        searchRelative(text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return textField.resignFirstResponder()
    }
}

extension HomeSearchViewController: UITableViewDelegate, UITableViewDataSource,HomeSearchFootDelegate,HomeSearchHeadDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == historyTableView {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == historyTableView {
            return section == 0 ? (searchHistory?.takeMax(5).count ?? 0) : 0
        } else if tableView == searchTableView {
            return relative?.count ?? 0
        }else {
            return comics?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == resultTableView {
            return 180
        } else {
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == historyTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            cell.textLabel?.text = searchHistory?[indexPath.row]
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        }
        else if tableView == searchTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            cell.textLabel?.text = relative?[indexPath.row].name
            cell.textLabel?.textColor = UIColor.darkGray
            cell.textLabel?.font = UIFont.systemFont(ofSize: 13)
            cell.separatorInset = .zero
            return cell
        }else if tableView == resultTableView {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: SeaichComicCell.self)
            cell.model = comics?[indexPath.row]
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(for: indexPath, cellType: BaseTableViewCell.self)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == historyTableView {
            searchResult(searchHistory[indexPath.row])
        } else if tableView == searchTableView {
            searchResult(relative?[indexPath.row].name ?? "")
        }else if tableView == resultTableView {
            guard let model = comics?[indexPath.row] else { return }
            let vc = HomeComicViewController(comicid: model.comicId)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return 44
        }else if tableView == searchTableView {
            return comics?.count ?? 0 > 0 ? 44 : CGFloat.leastNormalMagnitude
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView == historyTableView {
            let head = HomeSearchHead(section: section)
            head.titleLabel.text = section == 0 ? "看看你都搜过什么" : "大家都在搜"
            head.moreButton.setImage(section == 0 ? UIImage(named: "search_history_delete") : UIImage(named: "search_keyword_refresh"), for: .normal)
            head.moreButton.isHidden = section == 0 ? (searchHistory.count == 0) : false
            head.deleagte = self
            return head
        } else if tableView == searchTableView {
            let head = HomeSearchHead()
            head.titleLabel.text = "找到相关的漫画 \(comics?.count ?? 0) 本"
            head.moreButton.isHidden = true
            return head
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == historyTableView {
            return section == 0 ? 10 : tableView.frame.height - 44
        } else {
            return CGFloat.leastNormalMagnitude
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView == historyTableView && section == 1 {
            let foot = HomeSearchFoot()
            foot.data = hotItems ?? []
            foot.delegate = self
            return foot
        }
        return nil
        
    }
    
    func clickHomeSearchFootbtn(_ model: SearchItemModel) {
        let vc = HomeComicViewController(comicid: model.comic_id)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func clickHomeSearchHeadBtn(button: UIButton, section: Int) {
        if section == 0 {
            self.searchHistory?.removeAll()
            self.historyTableView.reloadData()
            UserDefaults.standard.removeObject(forKey: String.searchHistoryKey)
            UserDefaults.standard.synchronize()
        }
        if section == 1 {
            loadHistory()
        }
    }

    
}

