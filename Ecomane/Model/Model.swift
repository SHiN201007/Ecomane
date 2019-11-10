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
    
    var thumbnailImage: File?
    dynamic var name: String? // ニックネーム

  }
}

