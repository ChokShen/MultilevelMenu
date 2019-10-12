//
//  MultilevelMenuVariable.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/5/10.
//  Copyright © 2018年 shenzhiqiang. All rights reserved.
//

import Foundation
import UIKit

//屏幕
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
