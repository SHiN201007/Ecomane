//
//  ReportViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Charts
import Firebase
import Pring
import PKHUD

class ReportViewController: UIViewController {
  
  @IBOutlet weak var pieChartsView: PieChartView!
  @IBOutlet weak var balenceLabel: UILabel!
  @IBOutlet weak var tableView: UITableView!
  
  var inputDataSouce: DataSource<Firestore.Input>?
  
  var foodPrice: Int?
  var dailyPrice: Int?
  var tripPrice: Int?
  var trainPrice: Int?
  var beautyPrice: Int?
  var fashionPrice: Int?
  var utilityPrice: Int?
  var insurancePrice: Int?
  var phonePrice: Int?
  var studyPrice: Int?
  var carPrice: Int?
  var taxPrice: Int?
  var housePrice: Int?
  var balance = 0
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self

    getListData()
    tableView.register(UINib(nibName: "ReportTableViewCell", bundle: nil), forCellReuseIdentifier: "ReportCell")
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    self.tableView.reloadData()
    getBalanceData()
    setupPieChart()
  }
  
  // 残高取得
  private func getBalanceData() {
    HUD.show(.progress)
    guard let uid: String = Auth.auth().currentUser?.uid else { return } //データが取得できなかったらスキップ。
    Firestore.User.get(uid) { (user, error) in

       if let error = error {
          print(error)
          return
       }
      
      self.foodPrice = user?.foodPrice
      self.dailyPrice = user?.dailyPrice
      self.tripPrice = user?.tripPrice
      self.trainPrice = user?.trainPrice
      self.beautyPrice = user?.beautyPrice
      self.fashionPrice = user?.fashionPrice
      self.utilityPrice = user?.utilityPrice
      self.insurancePrice = user?.insurancePrice
      self.phonePrice = user?.phonePrice
      self.studyPrice = user?.studyPrice
      self.carPrice = user?.carPrice
      self.taxPrice = user?.taxPrice
      
      self.balance = user?.balance ?? 0
      self.balenceLabel.text = "残金：￥\(self.balance)"
      HUD.hide()
    }
  }
  
  private func reloadBalanceData() {
    HUD.show(.progress)
    guard let uid: String = Auth.auth().currentUser?.uid else { return } //データが取得できなかったらスキップ。
    Firestore.User.get(uid) { (user, error) in

       if let error = error {
          print(error)
          return
       }
      
      user?.foodPrice = self.foodPrice ?? 0
      user?.dailyPrice = self.dailyPrice ?? 0
      user?.tripPrice = self.tripPrice ?? 0
      user?.trainPrice = self.trainPrice ?? 0
      user?.beautyPrice = self.beautyPrice ?? 0
      user?.fashionPrice = self.fashionPrice ?? 0
      user?.utilityPrice = self.utilityPrice ?? 0
      user?.insurancePrice = self.insurancePrice ?? 0
      user?.phonePrice = self.phonePrice ?? 0
      user?.studyPrice = self.studyPrice ?? 0
      user?.carPrice = self.carPrice ?? 0
      user?.taxPrice = self.taxPrice ?? 0
      
      user?.balance = self.balance
      self.balenceLabel.text = "残金：￥\(user?.balance ?? 0)"
      HUD.hide()
    }
  }
  
  // 履歴の更新
  private func getListData() {
    HUD.show(.progress)
    guard let uid: String = Auth.auth().currentUser?.uid else { return }
    // あるuserが持っているbookの一覧を取得する
    let user = Firestore.User(id: uid)
    inputDataSouce = user.inputs.order(by: \Firestore.Input.createdAt).dataSource()
      .onCompleted() { (snapshot, inputs) in
        self.tableView.reloadData()
        HUD.hide()
      }.listen()
  }
  
  // 円グラフの取得
  func setupPieChart() {
    // 円グラフの中心に表示するタイトル
    self.pieChartsView.centerText = "今月の使用率"
    
    // グラフに表示するデータのタイトルと値
    var dataEntries: [Any] = []
    
    if foodPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(foodPrice ?? 0), label: "食費"))
    }else {
      dataEntries.removeAll()
    }
    
    if dailyPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(dailyPrice ?? 0), label: "日用品"))
    }else {
      dataEntries.removeAll()
    }
    
    if tripPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(tripPrice ?? 0), label: "お出かけ"))
    }else {
      dataEntries.removeAll()
    }
    
    if trainPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(trainPrice ?? 0), label: "交通費"))
    }else {
      dataEntries.removeAll()
    }
    
    if beautyPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(beautyPrice ?? 0), label: "美容"))
    }else {
      dataEntries.removeAll()
    }
    
    if fashionPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(fashionPrice ?? 0), label: "衣類"))
    }else {
      dataEntries.removeAll()
    }
    
    if utilityPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(foodPrice ?? 0), label: "光熱費"))
    }else {
      dataEntries.removeAll()
    }
    
    if insurancePrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(dailyPrice ?? 0), label: "保険"))
    }else {
      dataEntries.removeAll()
    }
    
    if phonePrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(tripPrice ?? 0), label: "通信"))
    }else {
      dataEntries.removeAll()
    }
    
    if studyPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(trainPrice ?? 0), label: "教育"))
    }else {
      dataEntries.removeAll()
    }
    
    if carPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(beautyPrice ?? 0), label: "車両"))
    }else {
      dataEntries.removeAll()
    }
    
    if taxPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(fashionPrice ?? 0), label: "税金"))
    }else {
      dataEntries.removeAll()
    }
    
    if housePrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(fashionPrice ?? 0), label: "家賃"))
    }else {
      dataEntries.removeAll()
    }
    
    
    let dataSet = PieChartDataSet(entries: dataEntries as? [ChartDataEntry], label: "データ")

    // グラフの色
    dataSet.colors = ChartColorTemplates.vordiplom()
    // グラフのデータの値の色
    dataSet.valueTextColor = UIColor.black
    // グラフのデータのタイトルの色
    dataSet.entryLabelColor = UIColor.black

    self.pieChartsView.data = PieChartData(dataSet: dataSet)
    
    // データを％表示にする
    let formatter = NumberFormatter()
    formatter.numberStyle = .percent
    formatter.maximumFractionDigits = 2
    formatter.multiplier = 1.0
    self.pieChartsView.data?.setValueFormatter(DefaultValueFormatter(formatter: formatter))
    self.pieChartsView.usePercentValuesEnabled = true
    
    view.addSubview(self.pieChartsView)
  }

}

extension ReportViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.inputDataSouce?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ReportCell") as! ReportTableViewCell
    
    categorizeImage(getCategory: inputDataSouce?[indexPath.row].category ?? "", cell:  cell) // 画像
    
    cell.categoryLabel.text = inputDataSouce?[indexPath.row].category
    cell.paymentLabel.text = inputDataSouce?[indexPath.row].payment
    
    switch inputDataSouce?[indexPath.row].payment {
      case "支払い":
        cell.paymentLabel.textColor = .red
      case "収入":
        cell.paymentLabel.textColor = .blue
      default:
        break
    }
    
    if inputDataSouce?[indexPath.row].introduce == "" {
      cell.introduceLabel.text = "コメントなし"
      cell.introduceLabel.textColor = .lightGray
    }
    
    cell.introduceLabel.text = inputDataSouce?[indexPath.row].introduce
    cell.daysLabel.text = inputDataSouce?[indexPath.row].days
    cell.priceLabel.text = "￥\(inputDataSouce?[indexPath.row].price ?? "0")"
    
    return cell
  }
  
}
extension ReportViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      self.inputDataSouce?.removeDocument(at: indexPath.row)
      
      switch inputDataSouce?[indexPath.row].category {
        case "食費":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          foodPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "日用品":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          dailyPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "お出かけ":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          tripPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "交通費":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          trainPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "美容費":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          beautyPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "衣類":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          fashionPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "光熱費":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          utilityPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "保険":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          insurancePrice? -= price ?? 0
          self.balance -= price ?? 0
        case "通信":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          phonePrice? -= price ?? 0
          self.balance -= price ?? 0
        case "教育":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          studyPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "車両":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          carPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "税金":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          taxPrice? -= price ?? 0
          self.balance -= price ?? 0
        case "家賃":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          housePrice? -= price ?? 0
          self.balance -= price ?? 0
        // 収入
        case "給料":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          self.balance -= price ?? 0
        case "臨時収入":
          let price = Int(inputDataSouce?[indexPath.row].price ?? "")
          self.balance -= price ?? 0
      default:
        break
      }
      reloadBalanceData() //
      setupPieChart() // 円グラフ反映
      
    } else if editingStyle == .insert {
    }
  }
}
