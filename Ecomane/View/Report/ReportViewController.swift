//
//  ReportViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Charts

class ReportViewController: UIViewController {
  
  @IBOutlet weak var pieChartsView: PieChartView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // 円グラフの中心に表示するタイトル
    self.pieChartsView.centerText = "今月のデータ"
    
    // グラフに表示するデータのタイトルと値
    let dataEntries = [
      PieChartDataEntry(value: 40, label: "A"),
      PieChartDataEntry(value: 35, label: "B"),
      PieChartDataEntry(value: 25, label: "C")
    ]
    
    let dataSet = PieChartDataSet(entries: dataEntries, label: "今月のデータ")

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
