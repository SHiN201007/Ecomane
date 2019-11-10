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

  }
}

extension Firestore {

  @objcMembers
  class Input: Object{
    
    dynamic var days: String? // 日にち
    dynamic var category: String?
    dynamic var introduce: String?
    dynamic var price: String?
  }
}



