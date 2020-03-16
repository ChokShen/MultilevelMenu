//
//  MultilevelPicker.swift
//  FWOMSMerchant
//
//  Created by ChokShen on 2018/5/10.
//  Copyright © 2018年 shenzhiqiang. All rights reserved.
//

import UIKit

public class MultilevelStyle1Menu: MultilevelStlyeMenu, MultilevelMenuStlye1ViewDelegate {
    
    override var hasNextLevel: Bool {
        didSet {
            if allowSelectAnyLevelData == false {
                if hasNextLevel == false {
                    setConfirmBtn(true)
                } else {
                    setConfirmBtn(false)
                }
            }
        }
    }
    static let upperViewHeight: CGFloat = 44
    static let height: CGFloat = MMScreen.isFullScreen ? 352 + MMScreen.bottomSafeHeight : 352
    static let confirmButtonHeight: CGFloat = 44
    private var tableViewFrame: CGRect {
        return CGRect(x: 0, y: MultilevelStyle1Menu.upperViewHeight, width: MMScreen.width, height: MultilevelStyle1Menu.height - MultilevelStyle1Menu.upperViewHeight - MultilevelStyle1Menu.confirmButtonHeight - MMScreen.bottomSafeHeight)
    }
    private var firstMenuView: MultilevelMenuStyle1View!
    private var customMenuView: MultilevelMenuStyle1View?
    private var confirmButton: UIButton!
    private lazy var containerView: UIView  = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: MMScreen.width, height: MMScreen.height - MultilevelStyle1Menu.height)
        containerView.backgroundColor = UIColor.protectedBackgroundColor
        containerView.isUserInteractionEnabled = true
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.cancelAction)))
        return containerView
    }()
    
    //MARK: - init
    @objc public convenience init(title: String?,
                                  fileUrl: URL,
                                  option: MultilevelMenuOption? = nil,
                                  customView: MultilevelMenuStyle1View? = nil,
                                  completion: SelectResultClosure?) {
        self.init(frame: CGRect(x: 0, y: MMScreen.height, width: MMScreen.width, height: MultilevelStyle1Menu.height))
        self.allDataSource = getDataSourceFromJsonFile(fileUrl)
        self.titleText = title
        if option != nil {
            self.defalutOption = option!
        } else {
            self.defalutOption = MultilevelMenuOption()
        }
        self.completion = completion
        self.customMenuView = customView
        layOut()
        setFirstDataSource()
    }
    
    @objc public convenience init(title: String?,
                                  dataSouce: [MenuDataModel],
                                  option: MultilevelMenuOption? = nil,
                                  customView: MultilevelMenuStyle1View? = nil,
                                  completion: SelectResultClosure?) {
        self.init(frame: CGRect(x: 0, y: MMScreen.height, width: MMScreen.width, height: MultilevelStyle1Menu.height))
        self.allDataSource = dataSouce
        self.titleText = title
        if option != nil {
            self.defalutOption = option!
        } else {
            self.defalutOption = MultilevelMenuOption()
        }
        self.completion = completion
        self.customMenuView = customView
        layOut()
        setFirstDataSource()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private func initMultilevelMenuView() -> MultilevelMenuStyle1View {
        if customMenuView == nil {
            return MultilevelMenuStyle1View()
        } else {
            let className = String(describing: type(of: customMenuView!))
            let projectName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let multilevelMenuView = NSClassFromString(projectName + "." + className) as! MultilevelMenuStyle1View.Type
            return multilevelMenuView.init()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handle Data
    override func setFirstDataSource() {
        super.setFirstDataSource()
        reminderLabel.text = self.titleText
        firstMenuView.dataSouce = firstMenuDataSource
    }
    
    //MARK: - Show & Cancel
    @objc override  public func show() {
        if allowSelectAnyLevelData {
            setConfirmBtn(true)
        } else {
            setConfirmBtn(false)
        }
        // 通过window 弹出view
        guard let window = UIApplication.shared.delegate?.window else { return }
        guard let currentWindow = window else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin = CGPoint(x: 0, y: MMScreen.height - MultilevelStyle1Menu.height)
            currentWindow.addSubview(self)
        }) { (finished) in
            if finished {
                currentWindow.addSubview(self.containerView)
            }
        }
    }
    
    @objc override func cancelAction() {
        self.containerView.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin = CGPoint(x: 0, y: MMScreen.height)
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Layout
    override func layOut() {
        self.backgroundColor = UIColor.white
        layOutUpperView()
        layOutMenuView()
        layOutConfirmButton()
    }
    
    override func layOutMenuView() {
        firstMenuView = initMultilevelMenuView()
        firstMenuView.frame = tableViewFrame
        firstMenuView.option = self.defalutOption
        firstMenuView.isFirst = true
        firstMenuView.delegate = self
        firstMenuView.tag = currentLevel
        self.addSubview(firstMenuView)
    }
    
    override func creatNextLevelMenuView(_ dataSouce: [MenuDataModel]) {
        let nextMenuView = initMultilevelMenuView()
        nextMenuView.frame = tableViewFrame
        nextMenuView.option = self.defalutOption
        nextMenuView.isFirst = false
        nextMenuView.delegate = self
        nextMenuView.dataSouce = dataSouce
        nextMenuView.tag = currentLevel
        self.addSubview(nextMenuView)
    }
    
    private func layOutUpperView() {
        upperBarView = UIView(frame: CGRect(x: 0, y: 0, width: MMScreen.width, height: MultilevelStyle1Menu.upperViewHeight))
        upperBarView.backgroundColor = UIColor.white
        self.addSubview(upperBarView)
        
        //提示标签
        reminderLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 70, height: upperBarView.frame.height - 0.5))
        reminderLabel.font = UIFont.systemFont(ofSize: 16)
        reminderLabel.text = self.titleText
        reminderLabel.textColor = UIColor.black
        upperBarView.addSubview(reminderLabel)
        //滚动视图
        let scrollViewX = reminderLabel.frame.maxX + 15
        scrollView = UIScrollView(frame: CGRect(x: scrollViewX, y: 0, width: MMScreen.width - scrollViewX, height: upperBarView.frame.height - 0.5))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 0)
        upperBarView.addSubview(scrollView)
        //分割线
        let seperator = UILabel(frame: CGRect(x: 0, y: reminderLabel.frame.maxY, width: upperBarView.frame.width, height: 0.5))
        seperator.backgroundColor = UIColor.seperatorLineColor
        upperBarView.addSubview(seperator)
    }
    
    private func layOutConfirmButton() {
        confirmButton = UIButton(type: .custom)
        confirmButton.frame = CGRect(x: 0, y: tableViewFrame.maxY, width: MMScreen.width, height: MultilevelStyle1Menu.confirmButtonHeight)
        confirmButton.setTitle(self.defalutOption.bottomButtonTitle, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmButton.setTitleColor(UIColor.white, for: .normal)
        confirmButton.setBackgroundImage(UIImage.imageWithColor(self.defalutOption.bottomButtonBackgroundColor_Disable), for: .normal)
        confirmButton.setBackgroundImage(UIImage.imageWithColor(self.defalutOption.bottomButtonBackgroundColor_Highlighted), for: .highlighted)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        self.addSubview(confirmButton)
        setConfirmBtn(false)
    }
    
    private func setConfirmBtn(_ enabled: Bool) {
        self.confirmButton.isEnabled = enabled
        if enabled {
            self.confirmButton.setBackgroundImage(UIImage.imageWithColor(self.defalutOption.bottomButtonBackgroundColor_Normal), for: .normal)
        } else {
            self.confirmButton.setBackgroundImage(UIImage.imageWithColor(self.defalutOption.bottomButtonBackgroundColor_Disable), for: .normal)
        }
    }
    
    //MARK: - Animation
    private func listViewHideAnimation(_ tag: Int, _ completion: AnimationCompletionClosure? = nil) {
        if let listView = self.viewWithTag(tag) as? MultilevelMenuStyle1View {
            listView.hideAnimation(completion)
        }
    }
    
    private func listViewRemoveFromSuperView(_ tag: Int) {
        if let listView = self.viewWithTag(tag) as? MultilevelMenuStyle1View {
            listView.removeFromSuperview()
        }
    }
    
    //MARK: - Scroll Button
    @objc override func clickName(_ sender: UIButton) {
        let clickedLevel = sender.tag - 200
        if clickedLevel < currentLevel {
            listViewHideAnimation(currentLevel, { (completion) in
                if completion {
                    for i in (clickedLevel + 1) ..< self.currentLevel {
                        self.listViewRemoveFromSuperView(i)
                    }
                    let low = clickedLevel + 1
                    for j in low ... self.currentLevel {
                        self.removeDisplayButton(j + 200)
                    }
                    self.isSelectLastLevelRow = false
                    self.currentLevel = clickedLevel
                    self.currentButton = self.scrollView.viewWithTag(self.currentLevel + 200) as? UIButton
                }
            })
            hasNextLevel = true
        }
    }
    
    // MARK: - PickerListViewDelegate
    public func didSelectRow(_ listView: MultilevelMenuStyle1View, _ row: Int, _ dateModel: MenuDataModel) {
        modelSelected = dateModel
        let nextLevelDataSouce = self.getNextLevelDataSouce(dateModel.id)
        hasNextLevel = nextLevelDataSouce.isEmpty ? false : true
        selectResultDisplay(dateModel.name)
        if hasNextLevel {
            currentLevel += 1
            creatNextLevelMenuView(nextLevelDataSouce)
        }
    }
}
