//
//  InputViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase

class InputViewController: UIViewController {
  
  
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var caterogyCollectionView: UICollectionView!

  //UIDatePickerを定義するための変数
  var datePicker: UIDatePicker = UIDatePicker()
  
  var items = [["name" : "食費", "imageName" : "food"],
               ["name" : "日用品", "imageName" : "daily"],
               ["name" : "お出かけ", "imageName" : "trip"],
               ["name" : "交通費", "imageName" : "train"],
               ["name" : "美容費", "imageName" : "beauty"],
               ["name" : "衣類", "imageName" : "fashion"],
              ]
  
  let selection = ["日付", "入力", " "] // セクション名
  let inputsList = ["カテゴリ","ひとこと", "金額"]
  let doneList = ["確定"]
  
  var todayField: UITextField?
  var categoryField: UITextField?
  var introduceField: UITextField?
  var moneyField: UITextField?
  
  var toolbar: UIToolbar?
  
  var today: String?
  var category: String?
  var introduce: String?
  var price: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // collectionView init
    caterogyCollectionView.dataSource = self
    caterogyCollectionView.delegate = self
    let nib = UINib(nibName: "CollectionViewCell", bundle: Bundle.main)
    caterogyCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    
    // tableView init
    tableView.dataSource = self
    tableView.delegate = self
    var tableCellNib = UINib(nibName: "DailyTableViewCell", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "dailyCell")
    tableCellNib = UINib(nibName: "inputTableViewCell", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "inputCell")
    tableCellNib = UINib(nibName: "DoneTableViewCell", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "doneCell")
    
    // レイアウト設定
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    layout.itemSize = CGSize(width: 100, height: 100)
    caterogyCollectionView.collectionViewLayout = layout
    
    setToday()
    createdDone()
    
//    let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(add))
//    self.navigationItem.rightBarButtonItem = addButton
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    todayField?.resignFirstResponder()
    categoryField?.resignFirstResponder()
    introduceField?.resignFirstResponder()
    moneyField?.resignFirstResponder()
  }
  
  func setData() {
    guard let uid: String = Auth.auth().currentUser?.uid else { return } //データが取得できなかったらスキップ。
    Firestore.User.get(uid) { (user, error) in

       if let error = error {
          print(error)
          return
       }

      let input = Firestore.Input()
      input.days = self.today
      input.category = self.category
      input.introduce = self.introduce
      input.price = self.price

      switch input.category {
        case "食費":
          user?.foodPrice += Int(input.price ?? "0") ?? 0
        case "日用品":
          user?.dailyPrice += Int(input.price ?? "0") ?? 0
        case "お出かけ":
          user?.tripPrice += Int(input.price ?? "0") ?? 0
        case "交通費":
          user?.trainPrice += Int(input.price ?? "0") ?? 0
        case "美容費":
          user?.beautyPrice += Int(input.price ?? "0") ?? 0
        case "衣類":
          user?.fashionPrice += Int(input.price ?? "0") ?? 0
      default:
        break
      }

      user?.balance -= Int(input.price ?? "0") ?? 0
      user?.inputs.insert(input)
      user?.update()
      
      print("成功")
    }
  }
  
  func setToday() {
    //現在の日付を取得
    let date:Date = Date()
    //日付のフォーマットを指定する。
    let format = DateFormatter()
    format.dateFormat = "yyyy年MM月dd日"
    //日付をStringに変換する
    today = format.string(from: date)
  }
  
  func createdDone() {
    // ピッカー設定
    datePicker.datePickerMode = UIDatePicker.Mode.date
    datePicker.timeZone = NSTimeZone.local
    datePicker.locale = Locale.current
    // todayField.inputView = datePicker

    // 決定バーの生成
    toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
    let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    toolbar?.setItems([spacelItem, doneItem], animated: true)
  }
  
  // UIDatePickerのDoneを押したら発火
  @objc func done() {
    todayField?.endEditing(true)
    // 日付のフォーマット
    let formatter = DateFormatter()
    //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
    formatter.dateFormat = "yyyy年MM月dd日"
    //(from: datePicker.date))を指定してあげることで
    //datePickerで指定した日付が表示される
    todayField?.text = "\(formatter.string(from: datePicker.date))"
  }
  
}

//MARK:- TableView Delegate
extension InputViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    switch indexPath.section {
        
      case 0:
        todayField?.becomeFirstResponder()
      case 1:
        switch indexPath.row {
          case 0:
            break
          case 1:
            introduceField?.becomeFirstResponder()
          case 2:
            moneyField?.becomeFirstResponder()
          default:
            break
        }
      case 2:
        today = todayField?.text
        introduce = introduceField?.text
        price = moneyField?.text
        
        setData()
      default:
        break
    }
  }
  
  // セクションの背景とテキストの色を変更する
  func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
      // 背景色を変更する
      view.tintColor = .orange

      let header = view as! UITableViewHeaderFooterView
      // テキスト色を変更する
      header.textLabel?.textColor = .white
  }

  
}

//MARK:- UITableViewDataSource

extension InputViewController: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return selection.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

    return selection[section]
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    switch section {
    case 0:
      return 1
    case 1:
      return inputsList.count
    case 2:
      return doneList.count
    default:
      return 0
    }
  }
  
//MARK:- cellForRowAt
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    switch indexPath.section {
      
    case 0:
      let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyTableViewCell
      
      todayField = cell.dailyTextField
      
      // インプットビュー設定(紐づいているUITextfieldへ代入)
      todayField?.inputView = datePicker
      todayField?.inputAccessoryView = toolbar
      
      todayField?.text = today
      return cell
      
    case 1:
      let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! inputTableViewCell
      
      switch indexPath.row {
      case 0:
        categoryField = cell.inputTextField
        categoryField?.placeholder = "カテゴリを選択してください"
        categoryField?.isEnabled = false
        categoryField?.borderStyle = .none
      case 1:
        introduceField = cell.inputTextField
      case 2:
        moneyField = cell.inputTextField
        moneyField?.keyboardType = .numberPad
      default:
        break
      }
      
      cell.inputLabel.text = inputsList[indexPath.row]
      return cell
      
    case 2:
      let cell = tableView.dequeueReusableCell(withIdentifier: "doneCell", for: indexPath) as! DoneTableViewCell
      
      cell.contentView.backgroundColor = .systemGreen
      cell.doneLabel.textColor = .white
      return cell
      
    default:
      let cell = tableView.dequeueReusableCell(withIdentifier: "doneCell", for: indexPath) as! DoneTableViewCell
      return cell
    }
    
  }
}

//MARK:- CollectionView Delegate

extension InputViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
    
    cell.label?.text = items[indexPath.row]["name"]
    cell.imagerView.image = UIImage(named: items[indexPath.row]["imageName"]!)
    
    return cell
  }
  
}
extension InputViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return items.count
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    categoryField?.text = items[indexPath.row]["name"]
    category = categoryField?.text
  }
}

//MARK:- TextField Delegate
extension InputViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    todayField?.resignFirstResponder()
    categoryField?.resignFirstResponder()
    introduceField?.resignFirstResponder()
    moneyField?.resignFirstResponder()

    return true
  }

}
