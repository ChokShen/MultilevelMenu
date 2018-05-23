//
//  MultilevelStlyeMenu.swift
//  MultilevelMenuDemo
//
//  Created by shenzhiqiang on 2018/5/14.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

public typealias SelectResultClosure = (String, MenuDataModel) -> Void

public class MultilevelStlyeMenu: UIView {
    
    var titleText: String?
    var allDataSource: [MenuDataModel] = []
    var firstMenuDataSource: [MenuDataModel] = []
    var modelSelected = MenuDataModel()
    var completion: SelectResultClosure?
    var defalutOption: MultilevelMenuOption = MultilevelMenuOption()
    ///false表示你必须要选择最后一级的数据才可以点确认按钮；true表示你可以选择任意一级的数据，然后确认结果
    var allowSelectAnyLevelData = false
    ///当前列表是第几级
    var currentLevel: Int = 1
    ///当前级别的行是否有下一级别的数据
    var hasNextLevel = true
    ///是否选中了最后一级列表的行
    var isSelectLastLevelRow = false
    var upperBarView: UIView!
    var reminderLabel: UILabel!
    var scrollView: UIScrollView!
    var currentButton: UIButton?
    var buttonTotalWidth: CGFloat = 0
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layOut()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Handle Data
    func getDataSourceFromJsonFile(_ url: URL) -> [MenuDataModel] {
        var dataSouce: [MenuDataModel] = []
        do{
            let data = try Data(contentsOf: url)
            let json:Any = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
            if let jsonArray = json as? [[String: String]] {
                for dict in jsonArray {
                    let model = MenuDataModel.init(dict: dict)
                    dataSouce.append(model)
                }
            }
        }catch let erro as Error?{
            print("读取本地数据出现错误！",erro!)
        }
        return dataSouce
    }
    
    func setFirstDataSource() {
        var tempDataSouce = [MenuDataModel]()
        for data in self.allDataSource {
            if data.pid == nil || data.pid == "" {
                tempDataSouce.append(data)
            }
        }
        self.firstMenuDataSource = tempDataSouce
    }
    
    func getNextLevelDataSouce(_ id: String?) -> [MenuDataModel] {
        var tempDataSouce = [MenuDataModel]()
        for data in self.allDataSource {
            if data.pid == id {
                tempDataSouce.append(data)
            }
        }
        return tempDataSouce
    }
    
    //MARK: - Show & Cancel
    func show() {
        
    }
    
    @objc func cancelAction() {
        
    }
    
    //MARK: - Layout
    func layOut() {
        
    }
    
    func layOutMenuView() {
        
    }
    
    func creatNextLevelMenuView(_ dataSouce: [MenuDataModel]) {
        
    }
    
    //MARK: - Scroll Button
    func selectResultDisplay(_ name: String?) {
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
    
    func creatDisplayButton(_ name: String?) {
        let buttonH = upperBarView.frame.height
        var text: String?
        if currentLevel == 1 {
            text = name
        } else {
            text = "  >  \(name ?? "")"
        }
        let buttonW_Text = text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: buttonH), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil).width
        let buttonW = buttonW_Text ?? 48
        let button = UIButton(frame: CGRect(x: buttonTotalWidth, y: 0, width: buttonW , height: buttonH))
        self.buttonTotalWidth += buttonW
        button.setTitleColor(defalutOption.upperBarButtonColor, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.tag = 200 + currentLevel
        if currentLevel == 1 {
            button.setTitle(name, for: .normal)
        } else {
            let attributedStr = NSMutableAttributedString.init(string: text ?? " ")
            attributedStr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], range: NSRange(location: 2, length: 1))
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
    
    func resetDisplayButton(_ name: String?) {
        let buttonH = upperBarView.frame.height
        var text: String?
        if currentLevel == 1 {
            text = name
        } else {
            text = "  >  \(name ?? "")"
        }
        let buttonW_Text = text?.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: buttonH), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil).width
        let buttonW = buttonW_Text ?? 48
        let currentButtonW = currentButton?.bounds.size.width
        currentButton?.frame.size = CGSize(width: buttonW, height: buttonH)
        if currentLevel == 1 {
            currentButton?.setTitle(name, for: .normal)
        } else {
            let attributedStr = NSMutableAttributedString.init(string: text ?? " ")
            attributedStr.addAttributes([NSAttributedStringKey.foregroundColor: UIColor.darkGray], range: NSRange(location: 2, length: 1))
            currentButton?.titleLabel?.textColor = defalutOption.upperBarButtonColor
            currentButton?.titleLabel?.attributedText = attributedStr
            currentButton?.setAttributedTitle(attributedStr, for: .normal)
        }
        self.buttonTotalWidth += (buttonW - currentButtonW!)
        scrollView.contentSize = CGSize(width: buttonTotalWidth, height: 0)
    }
    
    func removeDisplayButton(_ tag: Int) {
        if let button = scrollView.viewWithTag(tag) as? UIButton {
            button.removeFromSuperview()
            self.buttonTotalWidth -= button.frame.size.width
            scrollView.contentSize = CGSize(width: buttonTotalWidth, height: 0)
        }
    }
    
    @objc func clickName(_ sender: UIButton) {
        
    }
    
    // MARK: - Result Handle
    @objc func confirm() {
        if completion != nil {
            let combinedResultSting = getCombinedResultString()
            completion!(combinedResultSting, modelSelected)
        }
        cancelAction()
    }
    
    func getCombinedResultString() -> String {
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
    
}
