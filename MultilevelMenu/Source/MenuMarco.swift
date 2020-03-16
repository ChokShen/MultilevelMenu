//
//  MultilevelMenuVariable.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/5/10.
//  Copyright © 2018年 shenzhiqiang. All rights reserved.
//

import Foundation
import UIKit

struct MMScreen {
    ///屏幕宽度
    static let width = UIScreen.main.bounds.width
    ///屏幕高度
    static let height = UIScreen.main.bounds.height
    ///状态栏的高度
    static let statusBarHeight = UIApplication.shared.statusBarFrame.height
    ///导航栏的高度
    static let navigationBarHeight: CGFloat = 44
    ///状态栏+导航栏的高度
    static let navigationHeight = statusBarHeight + navigationBarHeight
    ///底部安全距离
    static let bottomSafeHeight: CGFloat = isFullScreen ? 34 : 0
    ///是否全面屏
    static var isFullScreen: Bool {
        if #available(iOS 11, *) {
              guard let w = UIApplication.shared.delegate?.window, let unwrapedWindow = w else {
                  return false
              }
              
              if unwrapedWindow.safeAreaInsets.bottom > 0 {
                  print(unwrapedWindow.safeAreaInsets)
                  return true
              }
        }
        return false
    }
    
}

///动画完成的代码块
public typealias AnimationCompletionClosure = (Bool) -> Void
///点击辅助按钮的代码块
public typealias ClickSupplementaryButtonClosure = (Int) -> Void
