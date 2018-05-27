//
//  MultilevelMenuController.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

public class MultilevelStyle2Menu: MultilevelStlyeMenu, MultilevelMenuStlye2ViewDelegate{

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
    private var defalutFrame: CGRect {
        return CGRect(x: 0, y: CSStatusBarHeight + CSNavigationBarHeight + MultilevelStyle2Menu.upperViewHeight, width: CSScreenW, height: CSScreenH - CSStatusBarHeight - CSNavigationBarHeight - MultilevelStyle2Menu.upperViewHeight)
    }
    private var firstMenuView: MultilevelMenuStyle2View!
    private var customMenuView: MultilevelMenuStyle2View?
    private var navigationBar: UIView!
    private var titltLabel: UILabel!
    private var confirmButton: UIButton!
    private var cancelButton: UIButton!
    
    //MARK: - init
    /// 初始化
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - fileUrl: 文件的路径
    ///   - option: 菜单的参数配置
    ///   - customView: 自定义视图
    ///   - completion: 选择结果的回调
    public convenience init(title: String?,
                fileUrl: URL,
                option: MultilevelMenuOption? = nil,
                customView: MultilevelMenuStyle2View? = nil,
                completion: SelectResultClosure?) {
        self.init(frame: CGRect(x: 0, y: CSScreenH, width: CSScreenW, height: CSScreenH))
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
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - dataSouce: 数据源
    ///   - option: 菜单的参数配置
    ///   - customView: 自定义视图
    ///   - completion: 选择结果的回调
    public convenience init(title: String?,
                dataSouce: [MenuDataModel],
                option: MultilevelMenuOption? = nil,
                customView: MultilevelMenuStyle2View? = nil,
                completion: SelectResultClosure?) {
        self.init(frame: CGRect(x: 0, y: CSScreenH, width: CSScreenW, height: CSScreenH))
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
    
    private func initMultilevelMenuView() -> MultilevelMenuStyle2View {
        if customMenuView == nil {
            return MultilevelMenuStyle2View()
        } else {
            let className = String(describing: type(of: customMenuView!))
            let projectName = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let multilevelMenuView = NSClassFromString(projectName + "." + className) as! MultilevelMenuStyle2View.Type
            return multilevelMenuView.init()
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Layout
    override func layOut() {
        self.backgroundColor = UIColor.white
        layOutMenuView()
        layOutCustomStatusBar()
        layOutCustomNavigationBar()
        layOutUpperView()
    }
    
    override func layOutMenuView() {
        firstMenuView = initMultilevelMenuView()
        firstMenuView.frame = defalutFrame
        firstMenuView.option = self.defalutOption
        firstMenuView.isFirst = true
        firstMenuView.delegate = self
        firstMenuView.tag = currentLevel
        self.addSubview(firstMenuView)
    }
    
    override func creatNextLevelMenuView(_ dataSouce: [MenuDataModel]) {
        let nextMenuView = initMultilevelMenuView()
        nextMenuView.frame = defalutFrame
        nextMenuView.option = self.defalutOption
        nextMenuView.isFirst = false
        nextMenuView.delegate = self
        nextMenuView.dataSouce = dataSouce
        nextMenuView.tag = currentLevel
        self.addSubview(nextMenuView)
    }
    
    private func layOutCustomStatusBar() {
        //自定义状态栏
        let statusBar = UIView(frame: CGRect(x: 0, y: 0, width: CSScreenW, height: CSStatusBarHeight))
        statusBar.backgroundColor = defalutOption.navigationBarColor
        self.addSubview(statusBar)
    }
    
    private func layOutCustomNavigationBar() {
        //自定义导航栏
        navigationBar = UIView(frame: CGRect(x: 0, y: CSStatusBarHeight, width: CSScreenW, height: CSNavigationBarHeight))
        navigationBar.backgroundColor = defalutOption.navigationBarColor
        self.addSubview(navigationBar)
        let leftEdge: CGFloat = 15
        //1.确定按钮
        confirmButton = UIButton(type: .custom)
        confirmButton.frame = CGRect(x: CSScreenW - leftEdge - 50, y: (navigationBar.frame.height - 30) / 2, width: 50, height: 30)
        confirmButton.contentHorizontalAlignment = .right
        confirmButton.setTitle(self.defalutOption.rightBarButtonTitle, for: .normal)
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        confirmButton.setTitleColor(self.defalutOption.rightBarButtonColor, for: .normal)
        confirmButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        setConfirmBtn(true)
        navigationBar.addSubview(confirmButton)
        //2.取消按钮
        cancelButton = UIButton(type: .custom)
        cancelButton.frame = CGRect(x: leftEdge, y: (navigationBar.frame.height - 18) / 2, width: 18, height: 18)
        let bundle = Bundle(for: MultilevelStlyeMenu.self)
        let closeImage = UIImage(named: "MultilevelMenuBundle.bundle/btn_common_close_wh", in: bundle, compatibleWith: nil)
        cancelButton.setImage(closeImage?.imageMaskWithColor(self.defalutOption.closeButtonColor), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelAction), for: .touchUpInside)
        navigationBar.addSubview(cancelButton)
        //3.标题
        titltLabel = UILabel(frame: CGRect(x: cancelButton.frame.maxX + leftEdge, y: (navigationBar.frame.height - 30) / 2, width: CSScreenW - confirmButton.frame.width - cancelButton.frame.width - 4 * leftEdge , height: 30))
        titltLabel.textAlignment = .center
        titltLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titltLabel.textColor = defalutOption.navigationTitleColor
        navigationBar.addSubview(titltLabel)
    }
    
    private func setConfirmBtn(_ enabled: Bool) {
        confirmButton.isEnabled = enabled
        if enabled {
            confirmButton.setTitleColor(defalutOption.rightBarButtonColor, for: .normal)
        } else {
            confirmButton.setTitleColor(UIColor.init(white: 0.2, alpha: 0.5), for: .normal)
        }
    }
    
    private func layOutUpperView() {
        upperBarView = UIView(frame: CGRect(x: 0, y: navigationBar.frame.maxY, width: CSScreenW, height: MultilevelStyle2Menu.upperViewHeight))
        upperBarView.backgroundColor = UIColor.white
        self.addSubview(upperBarView)
        
        reminderLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 70, height: upperBarView.frame.height - 1))
        reminderLabel.font = defalutOption.upperBarLeftTextFont
        reminderLabel.text = defalutOption.upperBarDefalutLeftText
        reminderLabel.textColor = defalutOption.upperBarLeftTextColor
        upperBarView.addSubview(reminderLabel)
        let scrollViewX = reminderLabel.frame.maxX
        scrollView = UIScrollView(frame: CGRect(x: scrollViewX, y: 0, width: CSScreenW - scrollViewX, height: upperBarView.frame.height - 1))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 0)
        upperBarView.addSubview(scrollView)
        
        let seperatorLine = UILabel(frame: CGRect(x: 0, y: reminderLabel.frame.maxY, width: CSScreenW, height: 1))
        seperatorLine.backgroundColor = UIColor.ColorFromRGB(rgbValue: 0xE1E1E1)
        upperBarView.addSubview(seperatorLine)
    }
    
    //MARK: - Handle Data
    override func setFirstDataSource() {
        super.setFirstDataSource()
        titltLabel.text = self.titleText
        firstMenuView.dataSouce = firstMenuDataSource
    }
    
    //MARK: - Show & Cancel
    override public func show() {
        if allowSelectAnyLevelData {
            setConfirmBtn(true)
        } else {
            setConfirmBtn(false)
        }
        // 通过window 弹出view
        let window = UIApplication.shared.keyWindow
        guard let currentWindow = window else { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin = CGPoint(x: 0, y: 0)
            currentWindow.addSubview(self)
        }) { (finished) in
            if finished {
            }
        }
    }
    
    @objc override func cancelAction() {
        UIView.animate(withDuration: 0.3, animations: {
            self.frame.origin = CGPoint(x: 0, y: CSScreenH)
        }) { (finished) in
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    //MARK: - Animation
    private func menuViewFullAnimation(_ tag: Int) {
        if let menuView = self.viewWithTag(tag) as? MultilevelMenuStyle2View {
            menuView.fullAnimation()
        }
    }
    
    private func menuViewBackToOriginalAnimation(_ tag: Int, _ completion: AnimationCompletionClosure? = nil) {
        if let menuView = self.viewWithTag(tag) as? MultilevelMenuStyle2View {
            menuView.popFromRightAnimation(completion)
        }
    }
    
    private func menuViewHideAnimation(_ tag: Int, _ completion: AnimationCompletionClosure? = nil) {
        if let menuView = self.viewWithTag(tag) as? MultilevelMenuStyle2View {
            menuView.hideAnimation_ClickButton(completion)
        }
    }
    
    private func menuViewRemoveFromSuperView(_ tag: Int) {
        if let menuView = self.viewWithTag(tag) as? MultilevelMenuStyle2View {
            menuView.removeFromSuperview()
        }
    }
    
    //MARK: - Scroll Button
    override func selectResultDisplay(_ name: String?) {
        super.selectResultDisplay(name)
        reminderLabel.text = defalutOption.upperBarSelectedLeftText
    }
    
    @objc override func clickName(_ sender: UIButton) {
        let clickedLevel = sender.tag - 200
        if clickedLevel < currentLevel {
            menuViewHideAnimation(currentLevel, { (completion) in
                if completion {
                    if clickedLevel != 1 {
                        self.menuViewBackToOriginalAnimation(clickedLevel, { (completion) in
                            if completion {
                                for i in (clickedLevel + 1) ..< self.currentLevel {
                                    self.menuViewRemoveFromSuperView(i)
                                }
                            }
                        })
                    } else {
                        for i in (clickedLevel + 1) ..< self.currentLevel {
                            self.menuViewRemoveFromSuperView(i)
                        }
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
    
    // MARK: - MultilevelMenuViewDelegate
    public func didSelectRow(_ menuView: MultilevelMenuStyle2View, _ row: Int, _ dataModel: MenuDataModel) {
        modelSelected = dataModel
        let nextLevelDataSouce = self.getNextLevelDataSouce(dataModel.id)
        hasNextLevel = nextLevelDataSouce.isEmpty ? false : true
        selectResultDisplay(dataModel.name)
        if hasNextLevel {
            menuViewFullAnimation(currentLevel)
            currentLevel += 1
            creatNextLevelMenuView(nextLevelDataSouce)
        }
    }
    
    public func didRemoveFromView(_ menuView: MultilevelMenuStyle2View) {
        let lastLevel = currentLevel - 1
        if lastLevel > 1 {
            menuViewBackToOriginalAnimation(lastLevel)
        }
        removeDisplayButton(currentLevel + 200)
        isSelectLastLevelRow = false
        currentLevel -= 1
        currentButton = scrollView.viewWithTag(currentLevel + 200) as? UIButton
        hasNextLevel = true
    }
    
    /*
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
