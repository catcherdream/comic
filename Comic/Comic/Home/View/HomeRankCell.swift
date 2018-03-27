//
//  HomeRankCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/23.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class HomeRankCell: BaseTableViewCell {

    var model: RankingModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.cover!))
            titleLabel.text = "\(model.title ?? "")榜"
            descLabel.text = model.subTitle
        }
    }
    
    
    fileprivate lazy var iconView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFill
        iw.clipsToBounds = true
        return iw
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        tl.font = UIFont.systemFont(ofSize: 18)
        return tl
    }()
    
    fileprivate lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
        dl.numberOfLines = 0
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    override func configUI() {
        
        let line = UIView().then{
            $0.backgroundColor = UIColor(red: 244, green: 244, blue: 244, alpha: 1)
        }
        contentView.addSubview(line)
        line.snp.makeConstraints{
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(10)
        }
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(line.snp.top).offset(-10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView).offset(20)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(iconView)
        }
    }
    

}
