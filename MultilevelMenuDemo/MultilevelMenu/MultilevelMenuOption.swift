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
    
    //MARK: - Common Option
    ///文本的字体
    public var textFont: UIFont = UIFont.systemFont(ofSize: 17)
    ///文本的颜色
    public var textColor: UIColor = UIColor.black
    ///勾选的颜色
    public var checkMarkColor: UIColor = UIColor.material_cyan_accent_normal
    ///顶部视图左边文字颜色
    public var upperBarLeftTextColor: UIColor = UIColor.ColorFromRGB(rgbValue: 0x999999)
    ///顶部视图左边文字字体
    public var upperBarLeftTextFont: UIFont = UIFont.boldSystemFont(ofSize: 16)
    ///顶部视图展示按钮的颜色
    public var upperBarButtonColor: UIColor = UIColor.material_cyan_accent_normal
    ///顶部视图展示按钮的字体
    public var upperBarButtonFont: UIFont = UIFont.boldSystemFont(ofSize: 17)
    
    //MARK: - Style1Menu Option
    public var bottomButtonTitle = "确定"
    public var bottomButtonBackgroundColor_Normal: UIColor = UIColor.material_cyan_accent_normal
    public var bottomButtonBackgroundColor_Disable: UIColor = UIColor.material_cyan_accent_disabled
    public var bottomButtonBackgroundColor_Highlighted: UIColor = UIColor.material_cyan_accent_highlighted
    
    //MARK: - Style2Menu Option
    ///次级菜单(级数大于1的菜单)的宽度
    public var secondaryMenuWidth: CGFloat = 80
    ///自定义导航栏的背景色
    public var navigationBarColor: UIColor = UIColor.navigationBarColor
    ///导航标题的颜色
    public var navigationTitleColor: UIColor = UIColor.black
    ///左侧关闭按钮的颜色
    public var closeButtonColor: UIColor = UIColor.black
    ///右侧导航按钮的标题
    public var rightBarButtonTitle: String = "确定"
    ///右侧导航按钮的颜色
    public var rightBarButtonColor: UIColor = UIColor.black
    ///顶部视图左边默认显示的文字
    public var upperBarDefalutLeftText = "请选择"
    ///选中菜单的一项后顶部视图左边显示的文字
    public var upperBarSelectedLeftText = "已选择"
}

//MARK: - Extension
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

extension UIColor {
    //RGB颜色
    class func ColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,blue: CGFloat(rgbValue & 0x0000FF) / 255.0,alpha: CGFloat(1.0)
        )
    }
    class var material_cyan_accent_disabled : UIColor
    {
        return self.ColorFromRGB(rgbValue: 0x18FFFF )
    }
    
    class var material_cyan_accent_normal : UIColor
    {
        return self.ColorFromRGB(rgbValue: 0x00E5FF )
    }
    
    class var material_cyan_accent_highlighted : UIColor
    {
        return self.ColorFromRGB(rgbValue: 0x00B8D4 )
    }
    
    class var protectedBackgroundColor : UIColor
    {
        return UIColor.init(white: 0.5, alpha: 0.5)
    }
    
    class var navigationBarColor : UIColor
    {
        return UIColor.init(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)
    }
    
    class var seperatorLineColor : UIColor {
        return self.ColorFromRGB(rgbValue: 0xE1E1E1)
    }
}

extension UIImage {
    func imageMaskWithColor(_ maskColor: UIColor) -> UIImage {
        var newImage:UIImage? = nil
        let imageRect = CGRect(origin: CGPoint(x: 0, y: 0), size: self.size)
        UIGraphicsBeginImageContextWithOptions(imageRect.size, false, self.scale)
        let context = UIGraphicsGetCurrentContext()
        context?.scaleBy(x: 1.0, y: -1.0)
        context?.translateBy(x: 0.0, y: -(imageRect.size.height))
        context?.clip(to: imageRect, mask: self.cgImage!);//选中选区 获取不透明区域路径
        context?.setFillColor(maskColor.cgColor);//设置颜色
        context?.fill(imageRect);//绘制
        newImage = UIGraphicsGetImageFromCurrentImageContext();//提取图片
        UIGraphicsEndImageContext()
        return newImage!
    }
}
