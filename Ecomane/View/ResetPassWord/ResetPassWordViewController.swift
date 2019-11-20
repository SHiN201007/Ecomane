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
  @IBOutlet weak var backButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    customCSS()
  }
  
  func customCSS() {
    resetButton.backgroundColor = .systemPink
    resetButton.layer.cornerRadius = 13.0
    resetButton.setTitleColor(.white, for: .normal)
    resetButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    
    backButton.backgroundColor = .white
    backButton.layer.cornerRadius = 13.0
    backButton.setTitleColor(.black, for: .normal)
    backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
  }
  
  @IBAction func resetButton(_ sender: Any) {
    let email = textField.text ?? ""
    HUD.flash(.label("メールを送信しました。"), delay: 1.5)
    Auth.auth().sendPasswordReset(withEmail: email) { error in
      if error != nil {
        // Start画面
        self.navigationController?.popToRootViewController(animated: true)
      }
    }
  }
  
  @IBAction func backButton(_ sender: Any) {
    // Start画面
    self.navigationController?.popToRootViewController(animated: true)
  }
  
  


}
