//
//  CustomCell.swift
//  MultilevelMenuDemo
//
//  Created by shenzhiqiang on 2018/5/7.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet weak var contenLabel: UILabel!
    @IBOutlet weak var seperator: UILabel! {
        didSet {
            seperator.backgroundColor = UIColor.white
        }
    }
    
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
