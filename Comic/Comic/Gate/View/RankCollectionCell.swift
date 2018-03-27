//
//  RankCollectionCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/22.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class RankCollectionCell: BaseCollectionViewCell {
 
    private lazy var iconView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        return imageview
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(iconView)
        contentView.addSubview(titleLabel)
        
        iconView.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.75)
        }
        
        titleLabel.snp.makeConstraints{
            $0.left.bottom.right.equalToSuperview()
            $0.top.equalTo(iconView.snp.bottom)
        }
    }
    
    
    
    var model: RankingModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconView.kf.setImage(with: URL(string: model.cover!))
            titleLabel.text = model.sortName!
            
        }
    }
    
    
}
