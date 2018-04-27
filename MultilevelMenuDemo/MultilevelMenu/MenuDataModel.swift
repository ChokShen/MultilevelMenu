//
//  MenuDataModel.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import Foundation

public struct MenuDataModel {
    ///Id of a piece of data in menu，required
    public var id: String?
    ///Data name，required
    public var name: String?
    ///Data value，optional
    public var value: String?
    ///Id of last-level menu，required
    public var pid: String?
    ///Menu current level，optional
    public var level: Int?
    
    init() {}
    
    init(dict: [AnyHashable: Any]) {
        self.id = dict["id"] as? String
        self.name = dict["name"] as? String
        self.value = dict["value"] as? String
        self.pid = dict["pid"] as? String
        self.level = dict["level"] as? Int
    }
    
}
