//
//  RealmModel.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import Pring
import Muni
import FirebaseFirestore

extension Firestore {

  @objcMembers
  class User: Object, UserProtocol {
    var name: String?
    var thumbnailImage: File?
    dynamic var balance: Int = 0 // 残高
    
    /// 支払い
    dynamic var foodPrice: Int = 0
    dynamic var dailyPrice: Int = 0
    dynamic var tripPrice: Int = 0
    dynamic var trainPrice: Int = 0
    dynamic var beautyPrice: Int = 0
    dynamic var fashionPrice: Int = 0
    dynamic var utilityPrice: Int = 0
    dynamic var insurancePrice: Int = 0
    dynamic var phonePrice: Int = 0
    dynamic var studyPrice: Int = 0
    dynamic var carPrice: Int = 0
    dynamic var taxPrice: Int = 0
    dynamic var housePrice: Int = 0
    
    dynamic var inputs: NestedCollection<Input> = []

  }
}

extension Firestore {

  @objcMembers
  class Input: Object{
    
    dynamic var days: String? // 日にち
    dynamic var category: String?
    dynamic var introduce: String?
    dynamic var price: String?
    dynamic var payment: String?
  }
}


