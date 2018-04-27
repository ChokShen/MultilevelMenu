//
//  MultilevelMenuOption.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import Foundation
import UIKit

public struct  MultilevelMenuOption {
    ///文本的字体
    public var textFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    ///文本的颜色
    public var textColor: UIColor = UIColor.black
    ///选中后文本的颜色
    public var selectedTextColor: UIColor = UIColor(red: 31/255, green: 182/255, blue: 252/255, alpha: 1)
    ///顶部视图背景颜色
    public var upperBarBackgroundColor: UIColor = UIColor.groupTableViewBackground
    ///顶部视图左边默认显示的文字
    public var upperBarDefalutLeftText = "请选择..."
    ///选中菜单的一项后顶部视图左边显示的文字
    public var upperBarSelectedLeftText = "已选择："
    ///顶部视图左边文字颜色
    public var upperBarLeftTextColor: UIColor = UIColor.gray
    ///顶部视图左边文字字体
    public var upperBarLeftTextFont: UIFont = UIFont.boldSystemFont(ofSize: 16)
    ///次级菜单(级数大于1的菜单)的宽度
    public var secondaryMenuWidth: CGFloat = 80
    ///顶部视图展示按钮的颜色
    public var upperBarButtonColor: UIColor = UIColor(red: 31/255, green: 182/255, blue: 252/255, alpha: 1)
    ///顶部视图展示按钮的字体
    public var upperBarButtonFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    ///右侧导航按钮的颜色
    public var rightBarButtonTitle = "确定"
    ///右侧导航按钮的颜色
    public var rightBarButtonColor: UIColor = UIColor.black
    ///辅助按钮文本的颜色
    public var supplementaryButtonTitleColor: UIColor = UIColor(red: 31/255, green: 182/255, blue: 252/255, alpha: 1)
    ///辅助按钮背景色
    public var supplementaryButtonBackgroundColor: UIColor = UIColor.groupTableViewBackground
    ///辅助按钮选中的背景色
    public var supplementaryButtonSelectedBackgroundColor: UIColor = UIColor(red: 31/255, green: 182/255, blue: 252/255, alpha: 1)
}

extension UIImage {
    //创建有颜色的image
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 18.0, height: 18.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}
