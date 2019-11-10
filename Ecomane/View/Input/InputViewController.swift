//
//  InputViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class InputViewController: UIViewController {
  
  @IBOutlet weak var todayField: UITextField!
  @IBOutlet weak var categoryField: UITextField!
  @IBOutlet weak var introduceField: UITextField!
  @IBOutlet weak var moneyField: UITextField!
  @IBOutlet weak var caterogyCollectionView: UICollectionView!
  
  //UIDatePickerを定義するための変数
  var datePicker: UIDatePicker = UIDatePicker()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    caterogyCollectionView.dataSource = self
    caterogyCollectionView.delegate = self
    
    // レイアウトを調整
    let layout = UICollectionViewFlowLayout()
    layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    caterogyCollectionView.collectionViewLayout = layout
    
    setToday()
    createdDone()
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
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) // 表示するセルを登録(先程命名した"Cell")
      cell.backgroundColor = .red  // セルの色
      return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let horizontalSpace : CGFloat = 20
      let cellSize : CGFloat = self.view.bounds.width / 3 - horizontalSpace
      return CGSize(width: cellSize, height: cellSize)
  }
  
}
extension InputViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
}
