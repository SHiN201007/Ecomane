//
//  AppSettingViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/18.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase

class AppSettingViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
    //menu-index
    enum cellIndex: Int {
      case logout = 0
    }
    //menu-title
    var menuTitle: [String] = [
      "ログアウト"
    ]
    
    override func viewDidLoad() {
      super.viewDidLoad()

      configure()
    }
    
    private let cellReuseIdentifier = "AppSettingViewCell"
    
    private func configure() {
      title = "設定"
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
  }

extension AppSettingViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuTitle.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    tableView.deselectRow(at: indexPath, animated: true)
    let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
    
    cell.accessoryType = .disclosureIndicator
    
    if let textLabel = cell.textLabel {
      textLabel.text = menuTitle[indexPath.row]
    }
    return cell
  }
}
extension AppSettingViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    switch indexPath.row {
    case cellIndex.logout.rawValue:
      do {
        try Auth.auth().signOut()
        // UserDefaultsに保存されている情報を全てクリア
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        self.navigationController?.popToRootViewController(animated: true)
      } catch _ {
        print("error")
        return
      }

    default:
      break
    }
  }
}

