//
//  MultilevelMenuView.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 shenzhiqiang. All rights reserved.
//

import UIKit

public protocol MultilevelMenuStlye2ViewDelegate: class {
    func didSelectRow(_ menuView: MultilevelMenuStyle2View, _ row: Int, _ dataModel: MenuDataModel)
    func didRemoveFromView(_ menuView: MultilevelMenuStyle2View)
}

open class MultilevelMenuStyle2View: MultilevelMenuView{
    
    override var initialWidth: CGFloat {
        get {
            return MMScreen.width - self.option.secondaryMenuWidth
        }
    }
    weak var delegate: MultilevelMenuStlye2ViewDelegate?
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.option.secondaryMenuWidth, height: self.bounds.height))
        backgroundView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideAnimation_ClickBackgroundView)))
        return backgroundView
    }()
    
    //MARK: - Animation
    override func popFromRightAnimation(_ completion: AnimationCompletionClosure? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = self.option.secondaryMenuWidth
        }) { (finished) in
            if finished {
                self.animationView.frame.size = CGSize(width: self.initialWidth, height: self.bounds.height)
                self.tableView.frame.size = CGSize(width: self.animationView.bounds.width, height: self.tableView.bounds.height)
                self.addSubview(self.backgroundView)
            }
        }
    }
    
    @objc func hideAnimation_ClickBackgroundView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = MMScreen.width
        }) { (finished) in
            if finished {
                self.backgroundView.removeFromSuperview()
                self.removeFromSuperview()
                self.delegate?.didRemoveFromView(self)
            }
        }
    }
    
   func hideAnimation_ClickButton(_ completion: AnimationCompletionClosure? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = MMScreen.width
        }) { (finished) in
            if finished {
                self.backgroundView.removeFromSuperview()
                self.removeFromSuperview()
                if completion != nil {
                    completion!(finished)
                }
            }
        }
    }
    
   func fullAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = 0
        }) { (finished) in
            if finished {
                self.animationView.frame.size = CGSize(width: MMScreen.width, height: self.bounds.height)
                self.tableView.frame.size = CGSize(width: self.animationView.bounds.width, height: self.tableView.bounds.height)
            }
        }
    }
    
    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        delegate?.didSelectRow(self, indexPath.row, dataSouce[indexPath.row])
    }
    
}
