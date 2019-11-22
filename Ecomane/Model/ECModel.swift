//
//  ECModel.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/15.
//  Copyright © 2019 松丸真. All rights reserved.
//

import Foundation
import UIKit


func categorizeImage(getCategory: String, cell:  ReportTableViewCell) {
  switch getCategory {
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
    case "光熱費":
      cell.categoryImage.image = UIImage(named: "utility")
    case "保険":
      cell.categoryImage.image = UIImage(named: "insurance")
    case "通信":
      cell.categoryImage.image = UIImage(named: "phone")
    case "教育":
      cell.categoryImage.image = UIImage(named: "study")
    case "車両":
      cell.categoryImage.image = UIImage(named: "car")
    case "税金":
      cell.categoryImage.image = UIImage(named: "tax")
    case "家賃":
      cell.categoryImage.image = UIImage(named: "house")
    // 収入
    case "給料":
      cell.categoryImage.image = UIImage(named: "salary")
    case "臨時収入":
      cell.categoryImage.image = UIImage(named: "bigSalary")
  default:
    break
  }
}


class CalendarModel {
  static var coverView: UIView?
  static var containerView: UIView?
}
