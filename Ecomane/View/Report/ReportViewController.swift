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
    self.pieChartsView.centerText = "今月のデータ"
    
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
    
    switch inputDataSouce?[indexPath.row].category {
      case "食費":
        cell.categoryImage.image = UIImage(named: "food")
      case "日用品":
      cell.categoryImage.image = UIImage(named: "daily")
      case "お出かけ":
      cell.categoryImage.image = UIImage(named: "trip")
      case "交通費":
        cell.categoryImage.image = UIImage(named: "train")
      case "美容費":
      cell.categoryImage.image = UIImage(named: "beauty")
      case "衣類":
      cell.categoryImage.image = UIImage(named: "fashion")
    default:
      break
    }
    
    cell.categoryLabel.text = inputDataSouce?[indexPath.row].category
    cell.paymentLabel.text = "支払い"
    cell.daysLabel.text = inputDataSouce?[indexPath.row].days
    cell.priceLabel.text = "￥\(inputDataSouce?[indexPath.row].price ?? "0")"
    
    return cell
  }
  
}
extension ReportViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
}
