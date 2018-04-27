//
//  MultilevelMenuController.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

public typealias SelectResultClosure = (String, MenuDataModel) -> Void

open class MultilevelMenuController: UIViewController, MultilevelMenuViewDelegate{
    
    ///多级菜单的所有数据
    public var allDataSource: [MenuDataModel] = []
    ///第一级菜单的数据
    public var firstMenuDataSource: [MenuDataModel] = []
    public var modelSelected = MenuDataModel()
    private var titleText: String?
    private var completion: SelectResultClosure?
    public var defalutOption: MultilevelMenuOption = MultilevelMenuOption()
    static let upperViewHeight: CGFloat = 44
    public var defalutFrame: CGRect {
        return CGRect(x: 0, y: MultilevelMenuController.upperViewHeight + 0.5, width: CSScreenW, height: CSScreenH - CSStatusBarHeight - CSNavigationBarHeight - MultilevelMenuController.upperViewHeight)
    }
    ///false表示你必须要选择最后一级的数据才可以点确认按钮；true表示你可以选择任意一级的数据，然后确认结果
    public var allowSelectAnyLevelData = false
    ///当前列表是第几级
    public var currentLevel: Int = 1
    ///当前级别的行是否有下一级别的数据
    public var hasNextLevel = true {
        didSet {
            if allowSelectAnyLevelData == false {
                if hasNextLevel == false {
                    setRightBarButtonItem(true)
                } else {
                    setRightBarButtonItem(false)
                }
            }
            
        }
    }
    ///是否选中了最后一级列表的行
    public var isSelectLastLevelRow = false
    
    private var upperBarView: UIView!
    private var reminderLabel: UILabel!
    private var scrollView: UIScrollView!
    private var currentButton: UIButton?
    private var buttonTotalWidth: CGFloat = 0
    
    public init(title: String?,
                fileUrl: URL,
                option: MultilevelMenuOption? = nil,
                completion: SelectResultClosure?) {
        super.init(nibName: nil, bundle: nil)
        self.allDataSource = getDataSourceFromJsonFile(fileUrl)
        self.titleText = title
        if option != nil {
            self.defalutOption = option!
        } else {
            self.defalutOption = MultilevelMenuOption()
        }
        self.completion = completion
        setFirstDataSource()
    }
    
    public init(title: String?,
                dataSouce: [MenuDataModel],
                option: MultilevelMenuOption? = nil,
                completion: SelectResultClosure?) {
        super.init(nibName: nil, bundle: nil)
        self.allDataSource = dataSouce
        self.titleText = title
        if option != nil {
            self.defalutOption = option!
        } else {
            self.defalutOption = MultilevelMenuOption()
        }
        self.completion = completion
        setFirstDataSource()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        addUI()
        configuration()
        // Do any additional setup after loading the view.
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getDataSourceFromJsonFile(_ url: URL) -> [MenuDataModel] {
        var dataSouce: [MenuDataModel] = []
        do{
            let data = try Data(contentsOf: url)
            let json:Any = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
            if let jsonArray = json as? [[String: String]] {
                for dict in jsonArray {
                    let dataModel = MenuDataModel.init(dict: dict)
                    dataSouce.append(dataModel)
                }
            }
        }catch {
            print("读取本地数据出现错误！",error)
        }
        return dataSouce
    }
    
    public func setFirstDataSource() {
        var tempDataSouce = [MenuDataModel]()
        for data in self.allDataSource {
            if data.pid == nil {
                tempDataSouce.append(data)
            }
        }
        self.firstMenuDataSource = tempDataSouce
    }
    
    public func getNextLevelDataSouce(_ id: String?) -> [MenuDataModel] {
        var tempDataSouce = [MenuDataModel]()
        for data in self.allDataSource {
            if data.pid == id {
                tempDataSouce.append(data)
            }
        }
        return tempDataSouce
    }
    
    private func addUI() {
        view.backgroundColor = UIColor.white
        layOutMenuView()
        layOutUpperView()
    }
    
    open func layOutMenuView() {
        let firstMenuView = MultilevelMenuView(frame: defalutFrame, option: defalutOption, isFirst: true)
        firstMenuView.delegate = self
        firstMenuView.dataSouce = firstMenuDataSource
        firstMenuView.tag = currentLevel
        self.view.addSubview(firstMenuView)
    }
    
    open func creatNextLevelMenuView(_ dataSouce: [MenuDataModel]) {
        let nextMenuView = MultilevelMenuView(frame: defalutFrame, option: defalutOption, isFirst: false)
        nextMenuView.delegate = self
        nextMenuView.dataSouce = dataSouce
        nextMenuView.tag = currentLevel
        self.view.addSubview(nextMenuView)
    }
    
    private func layOutUpperView() {
        upperBarView = UIView(frame: CGRect(x: 0, y: 0, width: CSScreenW, height: MultilevelMenuController.upperViewHeight))
        upperBarView.backgroundColor = defalutOption.upperBarBackgroundColor
        upperBarView.layer.shadowPath =  UIBezierPath(rect: upperBarView.bounds).cgPath
        upperBarView.layer.shadowRadius = 1
        upperBarView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        upperBarView.layer.shadowOpacity = 0.8
        upperBarView.layer.shadowColor = UIColor.lightGray.cgColor
        self.view.addSubview(upperBarView)
        
        reminderLabel = UILabel(frame: CGRect(x: 16, y: 0, width: 70, height: upperBarView.frame.height))
        reminderLabel.font = defalutOption.upperBarLeftTextFont
        reminderLabel.text = defalutOption.upperBarDefalutLeftText
        reminderLabel.textColor = defalutOption.upperBarLeftTextColor
        upperBarView.addSubview(reminderLabel)
        let scrollViewX = reminderLabel.frame.maxX
        scrollView = UIScrollView(frame: CGRect(x: scrollViewX, y: 0, width: CSScreenW - scrollViewX, height: upperBarView.frame.height))
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 0)
        self.view.addSubview(scrollView)
    }
    
    private func configuration() {
        self.navigationItem.title = self.titleText
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: defalutOption.rightBarButtonTitle, style: .plain, target: self, action: #selector(confirm))
        self.navigationItem.rightBarButtonItem?.tintColor = defalutOption.rightBarButtonColor
        if allowSelectAnyLevelData == false {
            setRightBarButtonItem(false)
        }
        self.edgesForExtendedLayout = .bottom
    }
    
    private func setRightBarButtonItem(_ enabled: Bool) {
        if enabled {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.navigationItem.rightBarButtonItem?.tintColor = defalutOption.rightBarButtonColor
        } else {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.init(white: 0.2, alpha: 0.8)
        }
    }
    
    @objc private func confirm() {
        if completion != nil {
            let combinedResultSting = getCombinedResultString()
            completion!(combinedResultSting, modelSelected)
        }
        self.dismiss(animated: true, completion: nil)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    public func menuViewFullAnimation(_ tag: Int) {
        if let menuView = self.view.viewWithTag(tag) as? MultilevelMenuView {
            menuView.fullAnimation()
        }
    }
    
    private func menuViewBackToOriginalAnimation(_ tag: Int, _ completion: AnimationCompletionClosure? = nil) {
        if let menuView = self.view.viewWithTag(tag) as? MultilevelMenuView {
            menuView.popFromRightAnimation(completion)
        }
    }
    
    private func menuViewHideAnimation(_ tag: Int, _ completion: AnimationCompletionClosure? = nil) {
        if let menuView = self.view.viewWithTag(tag) as? MultilevelMenuView {
            menuView.hideAnimation_ClickButton(completion)
        }
    }
    
    private func menuViewRemoveFromSuperView(_ tag: Int) {
        if let menuView = self.view.viewWithTag(tag) as? MultilevelMenuView {
            menuView.removeFromSuperview()
        }
    }
    
    open func selectResultDisplay(_ name: String?) {
        self.reminderLabel.text = defalutOption.upperBarSelectedLeftText
        if hasNextLevel {
            isSelectLastLevelRow = false
            if currentButton == nil {
                creatDisplayButton(name)
            } else {
                if (currentButton?.tag)! - 200 != currentLevel {
                    creatDisplayButton(name)
                } else {
                    resetDisplayButton(name)
                }
            }
        } else {
            if isSelectLastLevelRow == false {
                if currentButton == nil {
                    creatDisplayButton(name)
                } else if (currentButton?.tag)! - 200 != currentLevel {
                    creatDisplayButton(name)
                    isSelectLastLevelRow = true
                } else {
                    resetDisplayButton(name)
                }
            } else {
                if currentButton == nil {
                    creatDisplayButton(name)
                } else {
                    resetDisplayButton(name)
                }
            }
        }
    }
    
    private func creatDisplayButton(_ name: String?) {
        let buttonY: CGFloat = 0
        let buttonH = upperBarView.frame.height - 2 * buttonY
        var text: String?
        if currentLevel == 1 {
            text = name
        } else {
            text = "  >  \(name ?? "")"
        }
        let buttonW_Text = text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: buttonH), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)], context: nil).width
        let buttonW = buttonW_Text ?? 48
        let button = UIButton(frame: CGRect(x: buttonTotalWidth, y: buttonY, width: buttonW , height: buttonH))
        self.buttonTotalWidth += buttonW
        button.setTitleColor(defalutOption.upperBarButtonColor, for: .normal)
        button.titleLabel?.font = defalutOption.upperBarButtonFont
        button.tag = 200 + currentLevel
        if currentLevel == 1 {
            button.setTitle(name, for: .normal)
        } else {
            let attributedStr = NSMutableAttributedString.init(string: text ?? " ")
            attributedStr.addAttributes([NSForegroundColorAttributeName: UIColor.darkGray], range: NSRange(location: 2, length: 1))
            button.titleLabel?.textColor = defalutOption.upperBarButtonColor
            button.titleLabel?.attributedText = attributedStr
            button.setAttributedTitle(attributedStr, for: .normal)
        }
        button.addTarget(self, action: #selector(clickName(_:)), for: .touchUpInside)
        currentButton = button
        scrollView.addSubview(button)
        if self.buttonTotalWidth > scrollView.frame.width {
            scrollView.contentSize = CGSize(width: buttonTotalWidth, height: 0)
            scrollView.showsHorizontalScrollIndicator = true
            scrollView.flashScrollIndicators()
        }
    }
    
    private func resetDisplayButton(_ name: String?) {
        let buttonH = upperBarView.frame.height
        var text: String?
        if currentLevel == 1 {
            text = name
        } else {
            text = "  >  \(name ?? "")"
        }
        let buttonW_Text = text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: buttonH), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 17)], context: nil).width
        let buttonW = buttonW_Text ?? 48
        let currentButtonW = currentButton?.bounds.size.width
        currentButton?.frame.size = CGSize(width: buttonW, height: buttonH)
        if currentLevel == 1 {
            currentButton?.setTitle(name, for: .normal)
        } else {
            let attributedStr = NSMutableAttributedString.init(string: text ?? " ")
            attributedStr.addAttributes([NSForegroundColorAttributeName: UIColor.darkGray], range: NSRange(location: 2, length: 1))
            currentButton?.titleLabel?.textColor = defalutOption.upperBarButtonColor
            currentButton?.titleLabel?.attributedText = attributedStr
            currentButton?.setAttributedTitle(attributedStr, for: .normal)
        }
        self.buttonTotalWidth += (buttonW - currentButtonW!)
        scrollView.contentSize = CGSize(width: buttonTotalWidth, height: 0)
    }
    
    private func removeDisplayButton(_ tag: Int) {
        if let button = scrollView.viewWithTag(tag) as? UIButton {
            button.removeFromSuperview()
            self.buttonTotalWidth -= button.frame.size.width
            scrollView.contentSize = CGSize(width: buttonTotalWidth, height: 0)
        }
    }
    
    @objc private func clickName(_ sender: UIButton) {
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
    
    private func getCombinedResultString() -> String {
        var string = ""
        for i in 1 ... currentLevel {
            if let button = scrollView.viewWithTag(i + 200) as? UIButton {
                string += (button.titleLabel?.text)!
            }
        }
        string = string.replacingOccurrences(of: " ", with: "")
        string = string.replacingOccurrences(of: ">", with: " ")
        return string
    }
    
    // MARK: - MultilevelMenuViewDelegate
    public func didSelectRow(_ menuView: MultilevelMenuView, _ row: Int, _ dataModel: MenuDataModel) {
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
    
    public func didRemoveFromView(_ menuView: MultilevelMenuView) {
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
