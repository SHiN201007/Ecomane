//
//  StartViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
  
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    assignbackground()
    customCSS()
  }
  
  func assignbackground(){
      let background = UIImage(named: "bgImage1")

      var imageView : UIImageView!
      imageView = UIImageView(frame: view.bounds)
      imageView.contentMode =  UIView.ContentMode.scaleAspectFill
      imageView.clipsToBounds = true
      imageView.image = background
      imageView.center = view.center
      view.addSubview(imageView)
      self.view.sendSubviewToBack(imageView)
  }
  
  func customCSS() {
    registerButton.backgroundColor = .systemPink
    registerButton.layer.cornerRadius = 13.0
    registerButton.setTitleColor(.white, for: .normal)
    registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    
    loginButton.backgroundColor = .white
    loginButton.layer.cornerRadius = 13.0
    loginButton.setTitleColor(.black, for: .normal)
    loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
  }

  @IBAction func registerButton(_ sender: Any) {
    if let vc = UIStoryboard(name: "Register", bundle: nil).instantiateViewController(
      withIdentifier: "Register") as? RegisterViewController {
      vc.title = "新規会員登録"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  @IBAction func loginButton(_ sender: Any) {
    if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(
      withIdentifier: "Login") as? LoginViewController {
      vc.title = "ログイン"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}
