//
//  BaseViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()

    
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // ユーザがログインしていなければStart画面を表示
    presentStartPageIfNeeded()
  }

  private func presentStartPageIfNeeded() {
    if let _ = UserDefaults.standard.object(forKey: "loginID") {
      // User has already logged in.

    } else {
      if let startViewController = UIStoryboard(name: "Start", bundle: nil).instantiateViewController(
        withIdentifier: "Start") as? StartViewController {

        let naviController = ECNavigationController(rootViewController: startViewController)
        naviController.setNavigationBarHidden(true, animated: false)
        // フルスクリーン設定
        naviController.modalPresentationStyle = .fullScreen
        
        // Start画面を表示
        present(naviController, animated: true, completion: nil)
      }
    }
  }
}
