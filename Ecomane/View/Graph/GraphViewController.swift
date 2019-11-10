//
//  GraphViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Charts

class GraphViewController: UIViewController {

  @IBOutlet weak var barChartView: BarChartView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let unitsSold = [2000.0, 4000.0, 600.0, 300.0, 1200.0, 1600.0]

    createBarCharts(y: unitsSold)
  }
  
  private func createBarCharts(y:[Double]){
      var dataEntries = [BarChartDataEntry]()

      for(i,value) in y.enumerated(){
          let dataEntry = BarChartDataEntry(x: Double(i), y: value)
          dataEntries.append(dataEntry)
      }

      let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
      barChartView.data = BarChartData(dataSet: chartDataSet)

      //グラフの色
      chartDataSet.colors = [UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 0.8)]
  }

}
