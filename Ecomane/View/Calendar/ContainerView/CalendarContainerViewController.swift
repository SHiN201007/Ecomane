//
//  CalendarContainerViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/20.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit

class CalendarContainerViewController: UIViewController {

  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var inputButton: UIButton!
  @IBOutlet weak var closedButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(UINib(nibName: "CalendarTableViewCell", bundle: nil), forCellReuseIdentifier: "calendarCell")
    
    customCSS()
  }
  
  func customCSS() {
    inputButton.backgroundColor = .systemOrange
    inputButton.layer.cornerRadius = 13.0
    inputButton.setTitleColor(.black, for: .normal)
    inputButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
  }
  
  @IBAction func inputButton(_ sender: Any) {
    let UINavigationController = tabBarController?.viewControllers?[0];
    tabBarController?.selectedViewController = UINavigationController;
  }
  
  @IBAction func closedButton(_ sender: Any) {
    CalendarModel.coverView?.isHidden = true
    CalendarModel.containerView?.isHidden = true
  }
  
}
extension CalendarContainerViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "calendarCell") as! CalendarTableViewCell
    
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
