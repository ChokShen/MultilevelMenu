//
//  CustomMenuView.swift
//  MultilevelMenuDemo
//
//  Created by shenzhiqiang on 2018/5/7.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

class CustomMenuView: MultilevelMenuStyle1View {
    
    // MARK: - UITableViewDelegate
    open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("CustomCell", owner: nil, options: nil)?.first as? CustomCell
        }
        cell?.contenLabel?.text = dataSouce[indexPath.row].name
        cell?.tintColor = option.checkMarkColor
        if indexPath == lastSelectedIndexPath {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
