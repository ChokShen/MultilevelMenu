//
//  MultilevelMenuView.swift
//  MultilevelMenuDemo
//
//  Created by shenzhiqiang on 2018/5/14.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

open class MultilevelMenuView: UIView, UITableViewDelegate, UITableViewDataSource{

    var isFirst: Bool = false {
        didSet {
            if isFirst == false {
                self.addSubview(animationView)
                setUpLayOut()
                popFromRightAnimation()
            } else {
                animationView.frame = self.bounds
                self.addSubview(animationView)
                setUpLayOut()
            }
            tableViewConfiguration()
        }
    }
     public var option: MultilevelMenuOption = MultilevelMenuOption()
     var initialWidth: CGFloat {
        get {
            return CSScreenW
        }
    }
    
     public var dataSouce: [MenuDataModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
     lazy var animationView: UIView = {
        let animationView = UIView(frame: CGRect(x: CSScreenW, y: 0, width: self.initialWidth, height: self.bounds.height))
        animationView.backgroundColor = UIColor.white
        return animationView
    }()
     lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: CGRect.zero, style: .plain)
        return tempTableView
    }()
     var textLabel: UILabel!
     public var lastSelectedIndexPath: IndexPath?
    
    /// 便利初始化方法
    ///
    /// - Parameters:
    ///   - frame: 布局
    ///   - option: 配置参数
    ///   - isFirst: 是否第一级列表，默认为false
    ///   - isSupplementaryButton: 是否需要底部辅助按钮，默认为false
    convenience  init(frame: CGRect, option: MultilevelMenuOption, isFirst: Bool = false) {
        self.init(frame: frame)
        self.option = option
        if isFirst == false {
            self.addSubview(animationView)
            setUpLayOut()
            popFromRightAnimation()
        } else {
            animationView.frame = self.bounds
            self.addSubview(animationView)
            setUpLayOut()
        }
        tableViewConfiguration()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
    }
    
    public init (_ className: String?) {
        self.init()
    }
    
     func setUpLayOut() {
        self.tableView.frame = animationView.bounds
        animationView.addSubview(self.tableView)
    }
    
     func tableViewConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
    }
    
     func popFromRightAnimation(_ completion: AnimationCompletionClosure? = nil) {
    }
    
     func hideAnimation(_ completion: AnimationCompletionClosure? = nil) {
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
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - UITableViewDelegate & UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSouce.count
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "DisplayedCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "DisplayedCell")
        }
        cell?.textLabel?.text = dataSouce[indexPath.row].name
        cell?.textLabel?.textColor = option.textColor
        cell?.textLabel?.font = option.textFont
        cell?.tintColor = option.checkMarkColor
        if indexPath == lastSelectedIndexPath {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newIndexPath = indexPath
        if newIndexPath != lastSelectedIndexPath {
            let newCell = tableView.cellForRow(at: newIndexPath)
            newCell?.accessoryType = .checkmark
            newCell?.tintColor = option.checkMarkColor
            if lastSelectedIndexPath != nil {
                let lastSelectedCell = tableView.cellForRow(at: lastSelectedIndexPath!)
                lastSelectedCell?.accessoryType = .none
            }
            lastSelectedIndexPath = newIndexPath
        }
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}
