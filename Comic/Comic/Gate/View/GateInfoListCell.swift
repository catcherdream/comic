//
//  GateInfoListCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/22.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class GateInfoListCell: BaseTableViewCell {
    
    var spinnerName: String?
    
    fileprivate  lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    fileprivate  lazy var titleLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.black
        return tl
    }()
    
    fileprivate lazy var subTitleLabel: UILabel = {
        let sl = UILabel()
        sl.textColor = UIColor.gray
//        sl.text = "asda1dasdasdsd"
        sl.font = UIFont.systemFont(ofSize: 14)
        return sl
    }()
    
    fileprivate lazy var descLabel: UILabel = {
        let dl = UILabel()
        dl.textColor = UIColor.gray
//        dl.text = "asda1da123123123sdasdsd"
        dl.numberOfLines = 3
        dl.font = UIFont.systemFont(ofSize: 14)
        return dl
    }()
    
    fileprivate lazy var tagLabel: UILabel = {
        let tl = UILabel()
        tl.textColor = UIColor.orange
//        tl.text = "asda1da123123123sdasdsd"
        tl.font = UIFont.systemFont(ofSize: 14)
        return tl
    }()
    
    fileprivate lazy var orderView: UIImageView = {
        let ow = UIImageView()
        ow.contentMode = .scaleAspectFit
        return ow
    }()

    override func configUI() {
        
        contentView.addSubview(iconView)
        iconView.snp.makeConstraints {
            $0.left.top.bottom.equalToSuperview().inset(UIEdgeInsetsMake(10, 10, 10, 0))
            $0.width.equalTo(100)
        }
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
            $0.top.equalTo(iconView)
        }
        
        contentView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(20)
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(descLabel)
        descLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(60)
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(5)
        }
        
        contentView.addSubview(orderView)
        orderView.snp.makeConstraints {
            $0.bottom.equalTo(iconView.snp.bottom)
            $0.height.width.equalTo(30)
            $0.right.equalToSuperview().offset(-10)
        }
        
        contentView.addSubview(tagLabel)
        tagLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(10)
            $0.right.equalTo(orderView.snp.left).offset(-10)
            $0.height.equalTo(20)
            $0.bottom.equalTo(iconView.snp.bottom)
        }
    }
    
    var model: ComicModel? {
        didSet{
            guard let model = model else {
                return
            }
        
            iconView.kf.setImage(with: URL(string: model.cover!))
            titleLabel.text = model.name!
            subTitleLabel.text = "\(model.tags?.joined(separator: " ") ?? "") | \(model.author ?? "")"
            descLabel.text = model.description!
            
            if spinnerName == "更新时间" {
                let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(model.conTag)))
                var tagString = ""
                if comicDate < 60 {
                    tagString = "\(Int(comicDate))秒前"
                } else if comicDate < 3600 {
                    tagString = "\(Int(comicDate / 60))分前"
                } else if comicDate < 86400 {
                    tagString = "\(Int(comicDate / 3600))小时前"
                } else if comicDate < 31536000{
                    tagString = "\(Int(comicDate / 86400))天前"
                } else {
                    tagString = "\(Int(comicDate / 31536000))年前"
                }
                tagLabel.text = "\(spinnerName!) \(tagString)"
                orderView.isHidden = true
            }else {
                var tagString = ""
                if model.conTag > 100000000 {
                    tagString = String(format: "%.1f亿", Double(model.conTag) / 100000000)
                } else if model.conTag > 10000 {
                    tagString = String(format: "%.1f万", Double(model.conTag) / 10000)
                } else {
                    tagString = "\(model.conTag)"
                }
                if tagString != "0" {
                    tagLabel.text = "\(spinnerName ?? "总点击") \(tagString)"
                }
                orderView.isHidden = false
            }

        }
    }
    
    var index: IndexPath? {
        didSet {
            guard let index = index else {
                return
            }
            if index.row == 0 {
                orderView.image = UIImage.init(named: "rank_frist")
            }else if index.row == 1 {
                orderView.image = UIImage.init(named: "rank_second")
            }else if index.row == 2 {
                orderView.image = UIImage.init(named: "rank_third")
            }else {
                orderView.image = nil
            }
        }
    }
    
    

}
