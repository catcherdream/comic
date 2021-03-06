//
//  ComicUTicketCell.swift
//  Comic
//
//  Created by 唐硕 on 2018/3/26.
//  Copyright © 2018年 唐硕. All rights reserved.
//

import UIKit

class ComicUTicketCell: BaseTableViewCell {

    var model: DetailRealtimeModel? {
        didSet {
            guard let model = model else { return }
            let text = NSMutableAttributedString(string: "本月月票       |     累计月票  ",
                                                 attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,
                                                              NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)])
            text.append(NSAttributedString(string: "\(model.comic?.total_ticket ?? "")",
                attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange,
                             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]))
            text.insert(NSAttributedString(string: "\(model.comic?.monthly_ticket ?? "")",
                attributes: [NSAttributedStringKey.foregroundColor: UIColor.orange,
                             NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]),
                        at: 6)
            textLabel?.attributedText = text
            textLabel?.textAlignment = .center
        }
    }

}
