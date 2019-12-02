//
//  CalendarViewController.swift
//  Ecomane
//
//  Created by 松丸真 on 2019/11/11.
//  Copyright © 2019 松丸真. All rights reserved.
//

import UIKit
import FSCalendar
import CalculateCalendarLogic
import Firebase
import Pring
import PKHUD

class CalendarViewController: BaseViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
  
  @IBOutlet weak var calendar: FSCalendar!
  @IBOutlet weak var coverView: UIView!
  @IBOutlet weak var containerView: UIView!
  
  var inputDataSouce: DataSource<Firestore.Input>?
  var eventList: [String] = []
  var count = 0

  override func viewDidLoad() {
    super.viewDidLoad()
    
    CalendarModel.coverView = coverView
    CalendarModel.containerView = containerView
    
    setupCalendar()
    containerView.layer.cornerRadius = 7.0
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "設定", style: .done, target: self, action: #selector(appSetting))
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    containerView.isHidden = true
    coverView.isHidden = true
    getListData()
  }
  
  @objc func appSetting() {
    if let vc = UIStoryboard(name: "AppSetting", bundle: nil).instantiateViewController(
      withIdentifier: "AppSetting") as? AppSettingViewController {
      vc.title = "設定"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  func setupCalendar() {
    // delegate
    self.calendar.dataSource = self
    self.calendar.delegate = self
    self.calendar.appearance.headerDateFormat = "YYYY年MM月"
    self.calendar.appearance.headerTitleColor = UIColor(hex: 0xff6633, alpha: 1.0)
    // 曜日設定
    self.calendar.calendarWeekdayView.weekdayLabels[0].text = "日"
    self.calendar.calendarWeekdayView.weekdayLabels[1].text = "月"
    self.calendar.calendarWeekdayView.weekdayLabels[2].text = "火"
    self.calendar.calendarWeekdayView.weekdayLabels[3].text = "水"
    self.calendar.calendarWeekdayView.weekdayLabels[4].text = "木"
    self.calendar.calendarWeekdayView.weekdayLabels[5].text = "金"
    self.calendar.calendarWeekdayView.weekdayLabels[6].text = "土"
    self.calendar.calendarWeekdayView.weekdayLabels[0].textColor = UIColor.red
    self.calendar.calendarWeekdayView.weekdayLabels[1].textColor = UIColor.black
    self.calendar.calendarWeekdayView.weekdayLabels[2].textColor = UIColor.black
    self.calendar.calendarWeekdayView.weekdayLabels[3].textColor = UIColor.black
    self.calendar.calendarWeekdayView.weekdayLabels[4].textColor = UIColor.black
    self.calendar.calendarWeekdayView.weekdayLabels[5].textColor = UIColor.black
    self.calendar.calendarWeekdayView.weekdayLabels[6].textColor = UIColor.blue
  }
  
  fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
  fileprivate lazy var dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
  }()

  // 祝日判定を行い結果を返すメソッド(True:祝日)
  func judgeHoliday(_ date : Date) -> Bool {
    //祝日判定用のカレンダークラスのインスタンス
    let tmpCalendar = Calendar(identifier: .gregorian)

    // 祝日判定を行う日にちの年、月、日を取得
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)

    // CalculateCalendarLogic()：祝日判定のインスタンスの生成
    let holiday = CalculateCalendarLogic()

    return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
  }
  // date型 -> 年月日をIntで取得
  func getDay(_ date:Date) -> (Int,Int,Int){
    let tmpCalendar = Calendar(identifier: .gregorian)
    let year = tmpCalendar.component(.year, from: date)
    let month = tmpCalendar.component(.month, from: date)
    let day = tmpCalendar.component(.day, from: date)
    return (year,month,day)
  }

  //曜日判定(日曜日:1 〜 土曜日:7)
  func getWeekIdx(_ date: Date) -> Int{
    let tmpCalendar = Calendar(identifier: .gregorian)
    return tmpCalendar.component(.weekday, from: date)
  }

  // 土日や祝日の日の文字色を変える
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
    //祝日判定をする（祝日は赤色で表示する）
    if self.judgeHoliday(date){
      return UIColor.red
    }

    //土日の判定を行う（土曜日は青色、日曜日は赤色で表示する）
    let weekday = self.getWeekIdx(date)
    if weekday == 1 {   //日曜日
      return UIColor.red
    }
    else if weekday == 7 {  //土曜日
      return UIColor.blue
    }

    return nil
  }
  
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
    let color: UIColor = UIColor(hex: 0xff6633, alpha: 0.5)
    
    return color
  }
  
  // 角丸
  func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
    return 0.3
  }
  
  func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    if monthPosition == .previous || monthPosition == .next {
      calendar.setCurrentPage(date, animated: true)
    }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日"
    let dataString = formatter.string(from: date)
    
    if count == 0 {
      containerView.isHidden = true
      CalendarModel.today = ""
      count = 1
    }else if count == 1 {
      containerView.isHidden = false
      coverView.isHidden = false
      CalendarModel.today = dataString
      CalendarModel.dayLabel?.text = dataString
      coverView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
      count = 0
    }else {
      print("error")
    }
    
  }
  
  func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy年MM月dd日"
    let dataString = formatter.string(from: date)
    // print(dataString)
    if (eventList.firstIndex(of: dataString) != nil) {
      return 1
    }else {
      return 0
    }
  }
  
  private func getListData() {
    HUD.show(.progress)
    guard let uid: String = Auth.auth().currentUser?.uid else { return }
    // あるuserが持っているbookの一覧を取得する
    let user = Firestore.User(id: uid)
    inputDataSouce = user.inputs.order(by: \Firestore.Input.createdAt).dataSource()
      .onCompleted() { (snapshot, inputs) in
        for i in 0..<inputs.count{
          let ev = self.inputDataSouce?[i].days
          self.eventList.append(ev ?? "")
        }
        self.calendar.reloadData()
        HUD.hide()
      }.listen()
  }

}
