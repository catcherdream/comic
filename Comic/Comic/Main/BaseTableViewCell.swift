//
//  BaseTableViewCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/22.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit
import Reusable

class BaseTableViewCell: UITableViewCell,Reusable {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        configUI()
    }
    
    func configUI() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
