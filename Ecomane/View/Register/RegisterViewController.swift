//
//  RegisterViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import PKHUD

class RegisterViewController: UIViewController {

  @IBOutlet weak var emailField: UITextField!
  @IBOutlet weak var passwordField: UITextField!
  @IBOutlet weak var registerButton: UIButton!
  @IBOutlet weak var loginButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    emailField.delegate = self
    passwordField.delegate = self

    assignbackground()
    customCSS()
  }
  
  func assignbackground(){
      let background = UIImage(named: "harinezumi")

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
    loginButton.backgroundColor = .white
    loginButton.layer.cornerRadius = 13.0
    loginButton.setTitleColor(.black, for: .normal)
    loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    
    registerButton.backgroundColor = .systemPink
    registerButton.layer.cornerRadius = 13.0
    registerButton.setTitleColor(.white, for: .normal)
    registerButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
  }

  @IBAction func registerButton(_ sender: Any) {
    register()
  }
  
  @IBAction func loginButton(_ sender: Any) {
    if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(
      withIdentifier: "Login") as? LoginViewController {
      vc.title = "ログイン"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  
  func register() {
    Auth.auth().createUser(withEmail: emailField.text ?? "", password: passwordField.text ?? "") { (user, error) in
      HUD.show(.progress)
      if error != nil {
        print("登録できませんでした")
        HUD.show(.error)
        HUD.hide(afterDelay: 1.0)
      }
      else {
        print("登録できました")
        HUD.flash(.success, delay: 1.0)
        self.setdata()
        if let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(
          withIdentifier: "Login") as? LoginViewController {
          vc.title = "ログイン"
          self.navigationController?.pushViewController(vc, animated: true)
        }
      }
    }
  }
  
  func setdata() {
    if let currentUser = Auth.auth().currentUser { //データが取得できなかったらスキップ。
      let user = Firestore.User(id: currentUser.uid)
      let input = Firestore.Input()
      user.inputs.insert(input)
      input.delete()
      user.save()
    }
  }
}

//MARK:- TextField Delegate
extension RegisterViewController: UITextFieldDelegate {

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {

    emailField.resignFirstResponder()
    passwordField.resignFirstResponder()

    return true
  }

}
