//
//  PickerListView.swift
//  FWOMSMerchant
//
//  Created by ChokShen on 2018/5/10.
//  Copyright © 2018年 shenzhiqiang. All rights reserved.
//

import UIKit

public protocol MultilevelMenuStlye1ViewDelegate: class {
    func didSelectRow(_ listView: MultilevelMenuStyle1View, _ row: Int, _ dateModel: MenuDataModel)
}

open class MultilevelMenuStyle1View: MultilevelMenuView {
    
    weak var delegate: MultilevelMenuStlye1ViewDelegate?

    //MARK: - Animation
    override func popFromRightAnimation(_ completion: AnimationCompletionClosure? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = 0
        }) { (finished) in
            if finished {
                self.animationView.frame.size = CGSize(width: self.initialWidth, height: self.bounds.height)
                self.tableView.frame.size = CGSize(width: self.animationView.bounds.width, height: self.tableView.bounds.height)
            }
        }
    }
    
    override func hideAnimation(_ completion: AnimationCompletionClosure? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = CSScreenW
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
                if completion != nil {
                    completion!(finished)
                }
            }
        }
    }

    // MARK: - UITableViewDelegate & UITableViewDataSource
    open override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        delegate?.didSelectRow(self, indexPath.row, dataSouce[indexPath.row])
    }
}
