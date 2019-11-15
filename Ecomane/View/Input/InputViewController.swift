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
  @IBOutlet weak var paymentController: UISegmentedControl!
  
  //UIDatePickerを定義するための変数
  var datePicker: UIDatePicker = UIDatePicker()
  
  var items = [["name" : "食費", "imageName" : "food"],
                ["name" : "日用品", "imageName" : "daily"],
                ["name" : "お出かけ", "imageName" : "trip"],
                ["name" : "交通費", "imageName" : "train"],
                ["name" : "美容費", "imageName" : "beauty"],
                ["name" : "衣類", "imageName" : "fashion"],
                ["name" : "光熱費", "imageName" : "utility"],
                ["name" : "保険", "imageName" : "insurance"],
                ["name" : "通信", "imageName" : "phone"],
                ["name" : "教育", "imageName" : "study"],
                ["name" : "車両", "imageName" : "car"],
                ["name" : "税金", "imageName" : "tax"],
                ["name" : "家賃", "imageName" : "house"]
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
  var payment: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    payment = "支払い"
    
    todayField?.delegate = self
    categoryField?.delegate = self
    introduceField?.delegate = self
    moneyField?.delegate = self
    
    // collectionView init
    caterogyCollectionView.dataSource = self
    caterogyCollectionView.delegate = self
    let nib = UINib(nibName: "CollectionViewCell", bundle: Bundle.main)
    caterogyCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    caterogyCollectionView.isHidden = true
    
    // tableView init
    tableView.dataSource = self
    tableView.delegate = self
    self.tableView.tableFooterView = UIView() 
    var tableCellNib = UINib(nibName: "DailyTableViewCell", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "dailyCell")
    tableCellNib = UINib(nibName: "inputTableViewCell", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "inputCell")
    tableCellNib = UINib(nibName: "DoneTableViewCell", bundle: Bundle.main)
    tableView.register(tableCellNib, forCellReuseIdentifier: "doneCell")
    
    // レイアウト設定
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    layout.itemSize = CGSize(width: 70, height: 70)
    caterogyCollectionView.collectionViewLayout = layout
    
    setToday()
    createdDone()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    caterogyCollectionView.isHidden = true
    categoryField?.text = ""
    introduceField?.text = ""
    moneyField?.text = ""
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
      input.payment = self.payment

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
        case "光熱費":
          user?.utilityPrice += Int(input.price ?? "0") ?? 0
        case "保険":
          user?.insurancePrice += Int(input.price ?? "0") ?? 0
        case "通信":
          user?.phonePrice += Int(input.price ?? "0") ?? 0
        case "教育":
          user?.studyPrice += Int(input.price ?? "0") ?? 0
        case "車両":
          user?.carPrice += Int(input.price ?? "0") ?? 0
        case "税金":
          user?.taxPrice += Int(input.price ?? "0") ?? 0
        case "家賃":
        user?.housePrice += Int(input.price ?? "0") ?? 0
      default:
        break
      }
      
      if self.payment == "支払い" {
        user?.balance -= Int(input.price ?? "0") ?? 0
      }else {
        user?.balance += Int(input.price ?? "0") ?? 0
      }
      
      user?.inputs.insert(input)
      user?.update()
      
      print("成功")
      
      self.caterogyCollectionView.isHidden = true
      self.categoryField?.text = ""
      self.introduceField?.text = ""
      self.moneyField?.text = ""
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
  
  @IBAction func paymentControl(_ sender: UISegmentedControl) {
    
    switch sender.selectedSegmentIndex {
    case 0:
      payment = "支払い"
      items = [["name" : "食費", "imageName" : "food"],
       ["name" : "日用品", "imageName" : "daily"],
       ["name" : "お出かけ", "imageName" : "trip"],
       ["name" : "交通費", "imageName" : "train"],
       ["name" : "美容費", "imageName" : "beauty"],
       ["name" : "衣類", "imageName" : "fashion"],
       ["name" : "光熱費", "imageName" : "utility"],
       ["name" : "保険", "imageName" : "insurance"],
       ["name" : "通信", "imageName" : "phone"],
       ["name" : "教育", "imageName" : "study"],
       ["name" : "車両", "imageName" : "car"],
       ["name" : "税金", "imageName" : "tax"],
       ["name" : "家賃", "imageName" : "house"]]
      
      caterogyCollectionView.reloadData()
      
    case 1:
      payment = "収入"
      items = [["name" : "給料", "imageName" : "salary"],
       ["name" : "臨時収入", "imageName" : "bigSalary"]]
      
      caterogyCollectionView.reloadData()
    default:
      break
    }
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
            caterogyCollectionView.isHidden = false
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
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 35
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
        introduceField?.placeholder = "ex): 晩御飯・スーパー"
      case 2:
        moneyField = cell.inputTextField
        moneyField?.placeholder = "ex): ¥2500"
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

extension InputViewController: UITextFieldDelegate {
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    
    todayField?.resignFirstResponder()
    categoryField?.resignFirstResponder()
    introduceField?.resignFirstResponder()
    moneyField?.resignFirstResponder()
    
    return true
  }
}
