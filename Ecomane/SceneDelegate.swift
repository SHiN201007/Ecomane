//
//  SceneDelegate.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/10.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    // ViewControllers on TabBar
    var viewControllers: [UIViewController] = []

    // UITabBar.appearance().tintColor = bgColor

    // input画面
    if let inputViewController = UIStoryboard(name: "Input", bundle: nil).instantiateViewController(withIdentifier: "Input") as? InputViewController {

      inputViewController.title = "入力"

      // TabBarのアイコン
      let tabBarIcon = UITabBarItem(title: "入力",
                                    image: nil,
                                    tag: 0)
      inputViewController.tabBarItem = tabBarIcon

      let inputNaviController = ECNavigationController(rootViewController: inputViewController)
      viewControllers.append(inputNaviController)
    }
    
    // calendar画面
    if let calendarViewController = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: "Calendar") as? CalendarViewController {

      calendarViewController.title = "カレンダー"

      // TabBarのアイコン
      let tabBarIcon = UITabBarItem(title: "カレンダー",
                                    image: nil,
                                    tag: 1)
      calendarViewController.tabBarItem = tabBarIcon

      let calendarNaviController = ECNavigationController(rootViewController: calendarViewController)
      viewControllers.append(calendarNaviController)
    }
    
    // Report画面
    if let reportViewController = UIStoryboard(name: "Report", bundle: nil).instantiateViewController(withIdentifier: "Report") as? ReportViewController {

      reportViewController.title = "レポート"

      // TabBarのアイコン
      let tabBarIcon = UITabBarItem(title: "レポート",
                                    image: nil,
                                    tag: 2)
      reportViewController.tabBarItem = tabBarIcon

      let reportNaviController = ECNavigationController(rootViewController: reportViewController)
      viewControllers.append(reportNaviController)
    }
    
    let tabBarController = UITabBarController()
    tabBarController.setViewControllers(viewControllers, animated: false)
    tabBarController.selectedIndex = 1

    self.window = UIWindow(windowScene: windowScene)
    self.window?.rootViewController = tabBarController
    self.window?.makeKeyAndVisible()
  }

  func sceneDidDisconnect(_ scene: UIScene) {
    // Called as the scene is being released by the system.
    // This occurs shortly after the scene enters the background, or when its session is discarded.
    // Release any resources associated with this scene that can be re-created the next time the scene connects.
    // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
  }

  func sceneDidBecomeActive(_ scene: UIScene) {
    // Called when the scene has moved from an inactive state to an active state.
    // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
  }

  func sceneWillResignActive(_ scene: UIScene) {
    // Called when the scene will move from an active state to an inactive state.
    // This may occur due to temporary interruptions (ex. an incoming phone call).
  }

  func sceneWillEnterForeground(_ scene: UIScene) {
    // Called as the scene transitions from the background to the foreground.
    // Use this method to undo the changes made on entering the background.
  }

  func sceneDidEnterBackground(_ scene: UIScene) {
    // Called as the scene transitions from the foreground to the background.
    // Use this method to save data, release shared resources, and store enough scene-specific state information
    // to restore the scene back to its current state.
  }


}

