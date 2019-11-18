//
//  ResetPassWordViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/18.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class ResetPassWordViewController: UIViewController {
  
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var resetButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }
  
  @IBAction func resetButton(_ sender: Any) {
    let email = textField.text ?? ""
    HUD.flash(.label("メールを送信しました。"), delay: 1.5)
    Auth.auth().sendPasswordReset(withEmail: email) { error in
      if error != nil {
        // 送信完了画面へ
        self.navigationController?.popToRootViewController(animated: true)
      }
    }
  }
  


}
