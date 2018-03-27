//
//  ComicDescriptionCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/26.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class ComicDescriptionCell: BaseTableViewCell {

    fileprivate lazy var textView: UITextView = {
        let tw = UITextView()
        tw.isUserInteractionEnabled = false
        tw.textColor = UIColor.gray
        tw.font = UIFont.systemFont(ofSize: 15)
        return tw
    }()
    
    override func configUI() {
        let titileLabel = UILabel().then{
            $0.text = "作品介绍"
        }
        contentView.addSubview(titileLabel)
        titileLabel.snp.makeConstraints{
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsetsMake(15, 15, 15, 15))
            $0.height.equalTo(20)
        }
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints{
            $0.top.equalTo(titileLabel.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsetsMake(15, 15, 15, 15))
        }
    }
    
    var model: DetailStaticModel? {
        didSet{
            guard let model = model else { return }
            textView.text = "【\(model.comic?.cate_id ?? "")】\(model.comic?.description ?? "")"
        }
    }
    
    class func height(for detailStatic: DetailStaticModel?) -> CGFloat {
        var height: CGFloat = 50.0
        guard let model = detailStatic else { return height }
        let textView = UITextView().then{ $0.font = UIFont.systemFont(ofSize: 15) }
        textView.text = "【\(model.comic?.cate_id ?? "")】\(model.comic?.description ?? "")"
        height += textView.sizeThatFits(CGSize(width: screenWidth - 30, height: CGFloat.infinity)).height
        return height
    }

}
