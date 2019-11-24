//
//  CalendarContainerViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/20.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase
import PKHUD
import Pring

class CalendarContainerViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var inputButton: UIButton!
  @IBOutlet weak var closedButton: UIButton!
  @IBOutlet weak var todaysLabel: UILabel!
  
  var inputDataSouce: DataSource<Firestore.Input>?
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "calendarCell")
    
    CalendarModel.dayLabel = todaysLabel
    
    customCSS()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    getListData()
    todaysLabel.text = CalendarModel.today
  }
  
  func customCSS() {
    inputButton.backgroundColor = .systemOrange
    inputButton.layer.cornerRadius = 13.0
    inputButton.setTitleColor(.white, for: .normal)
    inputButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
    
    closedButton.layer.cornerRadius = 15.0
    closedButton.backgroundColor = .blue
    closedButton.setTitleColor(.white, for: .normal)
  }
  
  @IBAction func inputButton(_ sender: Any) {
    let UINavigationController = tabBarController?.viewControllers?[0];
    tabBarController?.selectedViewController = UINavigationController;
    CalendarModel.coverView?.isHidden = true
    CalendarModel.containerView?.isHidden = true
  }
  
  @IBAction func closedButton(_ sender: Any) {
    CalendarModel.coverView?.isHidden = true
    CalendarModel.containerView?.isHidden = true
  }
  
  // 履歴の更新
  private func getListData() {
    HUD.show(.progress)
    guard let uid: String = Auth.auth().currentUser?.uid else { return }
    // あるuserが持っているbookの一覧を取得する
    let user = Firestore.User(id: uid)
    inputDataSouce = user.inputs.order(by: \Firestore.Input.createdAt).dataSource()
      .onCompleted() { (snapshot, inputs) in
        self.tableView.reloadData()
        HUD.hide()
      }.listen()
  }
  
}
extension CalendarContainerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return inputDataSouce?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell") as! CalendarTableViewCell
    
    categorizeImage(getCategory: inputDataSouce?[indexPath.row].category ?? "", cell:  cell) // 画像
    
    cell.categoryLabel.text = inputDataSouce?[indexPath.row].category
    cell.paymentLabel.text = inputDataSouce?[indexPath.row].payment
    
    switch inputDataSouce?[indexPath.row].payment {
      case "支払い":
        cell.paymentLabel.textColor = .red
      case "収入":
        cell.paymentLabel.textColor = .blue
      default:
        break
    }
    
    if inputDataSouce?[indexPath.row].introduce == "" {
      cell.introduceLabel.text = "コメントなし"
      cell.introduceLabel.textColor = .lightGray
    }
    
    cell.introduceLabel.text = inputDataSouce?[indexPath.row].introduce
    cell.daysLabel.text = inputDataSouce?[indexPath.row].days
    cell.priceLabel.text = "￥\(inputDataSouce?[indexPath.row].price ?? "0")"
    
    return cell
  }
  
  
}
extension CalendarContainerViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 75
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
