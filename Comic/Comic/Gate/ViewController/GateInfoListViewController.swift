//
//  GateInfoListViewController.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/22.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class GateInfoListViewController: BaseViewController {

    fileprivate var argCon: Int = 0
    fileprivate var argName: String?
    fileprivate var argValue: Int = 0
    fileprivate var comicList = [ComicModel]()
    fileprivate var spinnerName: String?
    
    fileprivate lazy var tableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .plain)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(cellType: GateInfoListCell.self)
        return tableview
    }()
    
    convenience init(argCon: Int = 0,argName: String?,argValue: Int = 0) {
        self.init()
        self.argCon = argCon
        self.argName = argName
        self.argValue = argValue
        print(argCon, argName ?? "", argValue)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ApiLoadingProvider.request(ComicApi.comicList(argCon: argCon, argName: argName ?? "", argValue: argValue, page: 1), model: ComicListModel.self) { (returnData) in
            
            self.comicList = returnData?.comics ?? []
            guard let defaultParameters = returnData?.defaultParameters else { return }
            self.argCon = defaultParameters.defaultArgCon
            self.spinnerName = defaultParameters.defaultConTagType
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

extension GateInfoListViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comicList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  =  tableView.dequeueReusableCell(for: indexPath, cellType: GateInfoListCell.self)
        cell.spinnerName = spinnerName
        cell.index = indexPath
        cell.model = comicList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = comicList[indexPath.row]
        let vc = HomeComicViewController(comicid: model.comicId)
        navigationController?.pushViewController(vc, animated: true)
    }
    

    
    
}

