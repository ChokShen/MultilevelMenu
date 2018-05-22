# MultilevelMenu
A custom multi-level menu/ address picker.

## Requirements 
* iOS 8+
* Xcode 8+
* Swift 3.0+

## Installation 
### 1.CocoaPods
### 2.Manually
Download the project, then drag the files of MultilevelMenu folder to your project.

## Basic usage
### 1.Data structure
```
open class MenuDataModel {
///Id of a piece of data in menu，required
open var id: String?
///Data name，required
open var name: String?
///Data value，optional
open var value: String?
///Id of last-level menu，required
open var pid: String?
///Menu current level，optional
open var level: Int?

init() {}

init(dict: [AnyHashable: Any]) {
self.id = dict["id"] as? String
self.name = dict["name"] as? String
self.value = dict["value"] as? String
self.pid = dict["pid"] as? String
self.level = dict["level"] as? Int
}

}
```
### 2.Init

Data handle
```
let array: [Dictionary<String, String>] = [
["id":"01","name":"实物产品行业","value":""],
["id":"02","name":"服务行业","value":""],
["id":"0101","name":"综合超市/卖场","pid":"01","value":""],
["id":"0102","name":"穿戴用品","pid":"01","value":""],
["id":"0103","name":"饮食产品","pid":"01","value":""],
["id":"0104","name":"房地产","pid":"01","value":""]
]

var dataSouce: [MenuDataModel] = []
for dict in array {
let dataModel = MenuDataModel.init(dict: dict)
dataSouce.append(dataModel)
}
```
Show
```
let menu = MultilevelStyle1Menu(title: "行业类型", dataSouce: dataSouce, completion: { (resultString, model) in //'resultString' is combined with every level data that you have selected.'model' is the MenuDataModel that you have selected lastly.
self.resultLabel.text = resultString
})
menu.show()
```
## Custom Menu
* Custom Cell
Creat your custom cell by xib or code.
* Create a MultilevelMenuStyle1View or MultilevelMenuStyle2View subclass
```
class CustomMenuView: MultilevelMenuStyle2View {

// MARK: - UITableViewDelegate
open override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
var cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell") as? CustomCell
if cell == nil {
cell = Bundle.main.loadNibNamed("CustomCell", owner: nil, options: nil)?.first as? CustomCell
}
cell?.contenLabel?.text = dataSouce[indexPath.row].name //Text
cell?.iconImageView.image = UIImage(named: dataSouce[indexPath.row].value!) //Image

//Selected properties
cell?.tintColor = option.checkMarkColor
if indexPath == lastSelectedIndexPath {
cell?.accessoryType = .checkmark
} else {
cell?.accessoryType = .none
}
return cell!
}
}
```
*Show
```
var option = MultilevelMenuOption()
option.rightBarButtonTitle = "ok"
option.rightBarButtonColor = UIColor.red

let menu = MultilevelStyle2Menu(title: "请选择行业类型", dataSouce: dataSouce, option: option, customView: CustomMenuView(), completion: { (resultString, model) in
self.resultLabel.text = resultString
})
menu.show()
```
You also can creat MultilevelMenuOption to set menu custom properties.






