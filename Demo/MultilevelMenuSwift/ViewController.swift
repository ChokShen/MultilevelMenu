//
//  ViewController.swift
//  MultilevelMenuDemo
//
//  Created by ChokShen on 2018/4/27.
//  Copyright © 2018年 ChokShen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var customView: MultilevelMenuStyle1View!

    override func viewDidLoad() {
        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func getClassName(_ view: MultilevelMenuStyle1View) -> String {
        return String(describing: type(of: view))
    }
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBAction func testAction(_ sender: Any) {
        var dataSouce: [MenuDataModel] = []
        guard let path = Bundle.main.path(forResource:"businessType", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        do{
            let data = try Data(contentsOf: url)
            let json:Any = try JSONSerialization.jsonObject(with: data, options:JSONSerialization.ReadingOptions.mutableContainers)
            if let jsonArray = json as? [[String: String]] {
                for dict in jsonArray {
                    let dataModel = MenuDataModel.init(dict: dict)
                    dataSouce.append(dataModel)
                }
            }
        }catch{
            print("读取本地数据出现错误！",error)
        }
        let menu = MultilevelStyle1Menu(title: "行业类型", dataSouce: dataSouce, completion: { (resultString, model) in
            self.resultLabel.text = resultString
        })
        //menu.allowSelectAnyLevelData = true
        menu.show()
    }

    @IBAction func customMenu(_ sender: Any) {
        guard let path = Bundle.main.path(forResource:"businessType", ofType: "json") else { return }
        let url = URL(fileURLWithPath: path)
        let option = MultilevelMenuOption()
        option.rightBarButtonTitle = "ok"
        option.rightBarButtonColor = UIColor.red
        let menu = MultilevelStyle2Menu(title: "请选择行业类型", fileUrl: url, option: option, customView: CustomMenuView(), completion: { (resultString, model) in
            self.resultLabel.text = resultString
        })
        menu.show()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

