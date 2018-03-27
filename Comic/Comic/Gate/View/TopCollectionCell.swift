//
//  TopCollectionCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/19.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit
import Kingfisher

class TopCollectionCell: BaseCollectionViewCell {
   
    fileprivate var iconview : UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
        self.contentView.addSubview(iconview)
        iconview.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    var model: TopModel? {
        didSet {
            guard let model = model else {
                return
            }
            iconview.kf.setImage(with: URL(string:model.cover!))
        }
    }
    
    
    
}
