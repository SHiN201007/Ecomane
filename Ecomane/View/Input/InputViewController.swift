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
  
  @IBOutlet weak var todayField: UITextField!
  @IBOutlet weak var categoryField: UITextField!
  @IBOutlet weak var introduceField: UITextField!
  @IBOutlet weak var moneyField: UITextField!
  @IBOutlet weak var caterogyCollectionView: UICollectionView!
  
  var count = 0
  //UIDatePickerを定義するための変数
  var datePicker: UIDatePicker = UIDatePicker()
  
  var items = [["name" : "食費", "imageName" : "food"],
               ["name" : "日用品", "imageName" : "daily"],
               ["name" : "お出かけ", "imageName" : "trip"],
               ["name" : "交通費", "imageName" : "train"],
               ["name" : "美容費", "imageName" : "beauty"],
               ["name" : "衣類", "imageName" : "fashion"],
              ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    caterogyCollectionView.dataSource = self
    caterogyCollectionView.delegate = self
    let nib = UINib(nibName: "CollectionViewCell", bundle: Bundle.main)
    caterogyCollectionView.register(nib, forCellWithReuseIdentifier: "Cell")
    // レイアウト設定
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
    layout.itemSize = CGSize(width: 100, height: 100)
    caterogyCollectionView.collectionViewLayout = layout
    
    todayField.delegate = self
    categoryField.delegate = self
    introduceField.delegate = self
    moneyField.delegate = self
    
    setToday()
    createdDone()
    
    let addButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(add))
    self.navigationItem.rightBarButtonItem = addButton
  }
  
  // 追加ボタン
  @objc func add() {
    setData()
  }
  
  func setData() {
    count += 1
    guard let uid: String = Auth.auth().currentUser?.uid else { return } //データが取得できなかったらスキップ。
    Firestore.User.get(uid) { (user, error) in

       if let error = error {
          print(error)
          return
       }
      
      let input = Firestore.Input()
      input.days = self.todayField.text
      input.category = self.categoryField.text
      input.introduce = self.introduceField.text
      input.price = self.moneyField.text
      
      user?.balance -= Int(input.price ?? "0") ?? 0
      user?.inputs.insert(input)
      user?.update()
      
    }
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    todayField.resignFirstResponder()
    categoryField.resignFirstResponder()
    introduceField.resignFirstResponder()
    moneyField.resignFirstResponder()
  }
  
  func setToday() {
    //現在の日付を取得
    let date:Date = Date()
    //日付のフォーマットを指定する。
    let format = DateFormatter()
    format.dateFormat = "yyyy年MM月dd日"
    //日付をStringに変換する
    let sDate = format.string(from: date)
            
    print(sDate)
    todayField.text = "\(sDate)"
  }
  
  func createdDone() {
    // ピッカー設定
    datePicker.datePickerMode = UIDatePicker.Mode.date
    datePicker.timeZone = NSTimeZone.local
    datePicker.locale = Locale.current
    todayField.inputView = datePicker

    // 決定バーの生成
    let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
    let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
    let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    toolbar.setItems([spacelItem, doneItem], animated: true)

    // インプットビュー設定(紐づいているUITextfieldへ代入)
    todayField.inputView = datePicker
    todayField.inputAccessoryView = toolbar
  }
  
  // UIDatePickerのDoneを押したら発火
  @objc func done() {
    todayField.endEditing(true)
    // 日付のフォーマット
    let formatter = DateFormatter()
    //"yyyy年MM月dd日"を"yyyy/MM/dd"したりして出力の仕方を好きに変更できるよ
    formatter.dateFormat = "yyyy年MM月dd日"
    //(from: datePicker.date))を指定してあげることで
    //datePickerで指定した日付が表示される
    todayField.text = "\(formatter.string(from: datePicker.date))"
  }
  
}
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
    categoryField.text = items[indexPath.row]["name"]
  }
}

// keyBoard-Push-Done
extension InputViewController: UITextFieldDelegate {
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    todayField.resignFirstResponder()
    categoryField.resignFirstResponder()
    introduceField.resignFirstResponder()
    moneyField.resignFirstResponder()
    
    return true
  }
  
}
