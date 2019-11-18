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
    guard let uid: String = Auth.auth().currentUser?.uid else { return } //データが取得できなかったらスキップ。
    var balance = 0
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
      
      balance = user?.balance ?? 0
      self.balenceLabel.text = "残金：￥\(balance)"
    }
  }
  
  // 履歴の更新
  private func getListData() {
    guard let uid: String = Auth.auth().currentUser?.uid else { return }
    // あるuserが持っているbookの一覧を取得する
    let user = Firestore.User(id: uid)
    inputDataSouce = user.inputs.order(by: \Firestore.Input.createdAt).dataSource()
      .onCompleted() { (snapshot, inputs) in
        self.tableView.reloadData()
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
    }
    if dailyPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(dailyPrice ?? 0), label: "日用品"))
    }
    if tripPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(tripPrice ?? 0), label: "お出かけ"))
    }
    if trainPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(trainPrice ?? 0), label: "交通費"))
    }
    if beautyPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(beautyPrice ?? 0), label: "美容"))
    }
    if fashionPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(fashionPrice ?? 0), label: "衣類"))
    }
    if utilityPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(foodPrice ?? 0), label: "光熱費"))
    }
    if insurancePrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(dailyPrice ?? 0), label: "保険"))
    }
    if phonePrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(tripPrice ?? 0), label: "通信"))
    }
    if studyPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(trainPrice ?? 0), label: "教育"))
    }
    if carPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(beautyPrice ?? 0), label: "車両"))
    }
    if taxPrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(fashionPrice ?? 0), label: "税金"))
    }
    if housePrice ?? 0 > 0 {
      dataEntries.append(PieChartDataEntry(value: Double(fashionPrice ?? 0), label: "家賃"))
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
}
