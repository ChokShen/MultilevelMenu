//
//  MenuDataModel.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import Foundation

open class MenuDataModel: NSObject {
    ///Id of a piece of data in menu，required
    @objc open var id: String?
    ///Data name，required
    @objc open var name: String?
    ///Data value，optional
    @objc open var value: String?
    ///Id of last-level menu，required
    @objc open var pid: String?
    ///Menu current level，optional
    open var level: Int?
    
    public override init() {}
    
    @objc public init(dict: [AnyHashable: Any]) {
        self.id = dict["id"] as? String
        self.name = dict["name"] as? String
        self.value = dict["value"] as? String
        self.pid = dict["pid"] as? String
        self.level = dict["level"] as? Int
    }
    
}
