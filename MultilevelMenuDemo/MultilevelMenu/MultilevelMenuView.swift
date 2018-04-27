//
//  MultilevelMenuView.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

let CSScreenW = UIScreen.main.bounds.width
let CSScreenH = UIScreen.main.bounds.height
///状态栏的高度
let CSStatusBarHeight = UIApplication.shared.statusBarFrame.height
///导航栏的高度
let CSNavigationBarHeight: CGFloat = 44
///动画完成的代码块
public typealias AnimationCompletionClosure = (Bool) -> Void
///点击辅助按钮的代码块
public typealias ClickSupplementaryButtonClosure = (Int) -> Void

public protocol MultilevelMenuViewDelegate: class {
    func didSelectRow(_ menuView: MultilevelMenuView, _ row: Int, _ dataModel: MenuDataModel)
    func didRemoveFromView(_ menuView: MultilevelMenuView)
}

open class MultilevelMenuView: UIView, UITableViewDelegate, UITableViewDataSource{
    
    private var isFirst: Bool = false
    public var option: MultilevelMenuOption = MultilevelMenuOption()
    public var initialWidth: CGFloat {
        get {
            return CSScreenW - option.secondaryMenuWidth
        }
    }
    static let supplementaryViewHeight: CGFloat = 44
    
    public var dataSouce: [MenuDataModel] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    public weak var delegate: MultilevelMenuViewDelegate?
    public var clickSupplementaryButtonCallBack: ClickSupplementaryButtonClosure?
    
    private lazy var animationView: UIView = {
        let animationView = UIView(frame: CGRect(x: CSScreenW, y: 0, width: self.initialWidth, height: self.bounds.height))
        animationView.backgroundColor = UIColor.white
        return animationView
    }()
    private lazy var backgroundView: UIView = {
        let backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.option.secondaryMenuWidth, height: self.bounds.height))
        backgroundView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.hideAnimation_ClickBackgroundView)))
        return backgroundView
    }()
    private lazy var tableView: UITableView = {
        let tempTableView = UITableView(frame: CGRect.zero, style: .plain)
        return tempTableView
    }()
    public lazy var supplementaryButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.setTitleColor(self.option.supplementaryButtonTitleColor, for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(self.option.supplementaryButtonBackgroundColor), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(self.option.supplementaryButtonSelectedBackgroundColor), for: .highlighted)
        button.addTarget(self, action: #selector(clickSupplementaryButtonAction), for: .touchUpInside)
        return button
    }()
    private var textLabel: UILabel!
    
    /// 便利初始化方法
    ///
    /// - Parameters:
    ///   - frame: 布局
    ///   - option: 配置参数
    ///   - isFirst: 是否第一级列表，默认为false
    ///   - isSupplementaryButton: 是否需要底部辅助按钮，默认为false
    convenience public init(frame: CGRect, option: MultilevelMenuOption, isFirst: Bool = false, isSupplementaryButton: Bool = false) {
        self.init(frame: frame)
        self.option = option
        if isFirst == false {
            self.addSubview(animationView)
            setUpLayOut(isSupplementaryButton)
            popFromRightAnimation()
        } else {
            animationView.frame = self.bounds
            self.addSubview(animationView)
            setUpLayOut(isSupplementaryButton)
        }
        tableViewConfiguration()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.init(white: 0.5, alpha: 0.5)
    }
    
    open func setUpLayOut(_ isSupplementaryView: Bool) {
        if isSupplementaryView {
            self.tableView.frame = CGRect(x: 0, y: 0, width: animationView.bounds.width, height: animationView.bounds.height - MultilevelMenuView.supplementaryViewHeight)
            animationView.addSubview(self.tableView)
            self.supplementaryButton.frame = CGRect(x: 0, y: self.tableView.bounds.height + 1, width: animationView.bounds.width, height: MultilevelMenuView.supplementaryViewHeight)
            self.supplementaryButton.backgroundColor = self.option.supplementaryButtonBackgroundColor
            self.supplementaryButton.layer.shadowPath =  UIBezierPath(rect: self.supplementaryButton.bounds).cgPath
            self.supplementaryButton.layer.shadowRadius = 1
            self.supplementaryButton.layer.shadowOffset = CGSize(width: 1, height: 1)
            self.supplementaryButton.layer.shadowOpacity = 0.8
            self.supplementaryButton.layer.shadowColor = UIColor.black.cgColor
            animationView.addSubview(self.supplementaryButton)
        } else {
            self.tableView.frame = animationView.bounds
            animationView.addSubview(self.tableView)
        }
    }
    
    private func tableViewConfiguration() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
    }
    
    public func popFromRightAnimation(_ completion: AnimationCompletionClosure? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = self.option.secondaryMenuWidth
        }) { (finished) in
            if finished {
                self.animationView.frame.size = CGSize(width: self.initialWidth, height: self.bounds.height)
                self.tableView.frame.size = CGSize(width: self.animationView.bounds.width, height: self.tableView.bounds.height)
                self.supplementaryButton.frame.size = CGSize(width: self.animationView.bounds.width, height: MultilevelMenuView.supplementaryViewHeight)
                self.addSubview(self.backgroundView)
            }
        }
    }
    
    public func hideAnimation_ClickBackgroundView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = CSScreenW
        }) { (finished) in
            if finished {
                self.backgroundView.removeFromSuperview()
                self.removeFromSuperview()
                self.delegate?.didRemoveFromView(self)
            }
        }
    }
    
    public func hideAnimation_ClickButton(_ completion: AnimationCompletionClosure? = nil) {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = CSScreenW
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
    
    public func fullAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.animationView.frame.origin.x = 0
        }) { (finished) in
            if finished {
                self.animationView.frame.size = CGSize(width: CSScreenW, height: self.bounds.height)
                self.tableView.frame.size = CGSize(width: self.animationView.bounds.width, height: self.tableView.bounds.height)
                self.supplementaryButton.frame.size = CGSize(width: self.animationView.bounds.width, height: MultilevelMenuView.supplementaryViewHeight)
            }
        }
    }
    
    @objc private func clickSupplementaryButtonAction() {
        if clickSupplementaryButtonCallBack != nil {
            clickSupplementaryButtonCallBack!(self.tag)
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
        return cell!
    }
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        for i in 0 ..< dataSouce.count {
            if indexPath.row == i {
                let cell = tableView.cellForRow(at: indexPath)
                cell?.textLabel?.textColor = option.selectedTextColor
            } else {
                let tempIndexPath = IndexPath(row: i, section: 0)
                let cell = tableView.cellForRow(at: tempIndexPath)
                cell?.textLabel?.textColor = option.textColor
            }
        }
        delegate?.didSelectRow(self, indexPath.row, dataSouce[indexPath.row])
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
}
