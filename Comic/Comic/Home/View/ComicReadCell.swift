//
//  ComicReadCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/27.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class ComicReadCell: BaseCollectionViewCell {

     fileprivate lazy var imageView: UIImageView = {
        let iw = UIImageView()
        iw.contentMode = .scaleAspectFit
        return iw
    }()
    
    fileprivate lazy var placeholder: UIImageView = {
        let pr = UIImageView(image: UIImage(named: "yaofan"))
        pr.contentMode = .center
        return pr
    }()
    
    override func configUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    var model: ImageModel? {
        didSet {
            guard let model = model else { return }
            imageView.image = nil
            imageView.kf.setImage(with: URL(string: model.location!))

        }
    }

}
