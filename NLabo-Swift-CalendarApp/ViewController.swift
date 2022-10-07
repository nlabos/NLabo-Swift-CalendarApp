//
//  ViewController.swift
//  NLabo-Swift-CalendarApp
//
//  Created by 髙津悠樹 on 2022/09/28.
//

//誕生日の処理は含めていません


import UIKit
import RealmSwift
import CalculateCalendarLogic
import FSCalendar

let width = UIScreen.main.bounds.size.width
let height = UIScreen.main.bounds.size.height

class ViewController: UIViewController, FSCalendarDelegate, FSCalendarDelegateAppearance, FSCalendarDataSource {
    
    let dateView = FSCalendar(frame: CGRect(x: 0, y: 30, width: width, height: 400))
    let scheduleView = UIView(frame: CGRect(x: 0, y: 430, width: width, height: height))
    let titleLabel = UILabel(frame: CGRect(x: 0, y: 80, width: 180, height: 40))
    let contentLabel = UILabel(frame: CGRect(x: 5, y: 120, width: 400, height: 100))
    let selectedDateLabel = UILabel(frame: CGRect(x: 5, y: 0, width: 350, height: 100))
    //スケジュール追加ボタン
    let addBtn = UIButton(frame: CGRect(x: width - 80, y: height - 90, width: 60, height: 60))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //カレンダーの設定
        self.dateView.dataSource = self
        self.dateView.delegate = self
        self.dateView.today = nil
        
        view.addSubview(dateView)
        
        scheduleView.backgroundColor = UIColor.blue
        view.addSubview(scheduleView)
        
        //「主なスケジュール」表示設定
        titleLabel.text = "主なスケジュール"
        titleLabel.backgroundColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20.0)
        scheduleView.addSubview(titleLabel)
        
        //スケジュール内容表示設定
        contentLabel.text = "スケジュールはありません"
        contentLabel.textColor = .white
        contentLabel.textAlignment = .center
        contentLabel.font = UIFont.systemFont(ofSize: 18.0)
        scheduleView.addSubview(contentLabel)
        
        //日付表示設定
       // selectedDateLabel.text = "09/28"
        selectedDateLabel.textColor = .white
        selectedDateLabel.font = UIFont.systemFont(ofSize: 40.0)
        scheduleView.addSubview(selectedDateLabel)
        
        addBtn.backgroundColor = UIColor(red: 0/255, green: 100/255, blue: 255/255, alpha: 1)
        addBtn.setTitle("+", for: UIControl.State())
        addBtn.setTitleColor(.white, for: UIControl.State())
        addBtn.layer.cornerRadius = 30.0
        addBtn.addTarget(self, action: #selector(onClick), for: .touchUpInside)
        view.addSubview(addBtn)
        
        //今日の日付を取得する
        let now = Date()
        calendar(dateView, didSelect: now, at: .current)
        //カレンダー上でも選択する
        dateView.select(now)
        
       
    }
    //編集画面から戻ってきた時に編集内容を更新する
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getschedule(date: selectedDateLabel.text!)
    }
    //祝日判定を行なって結果を返すメソッド
    func judgeHoliday(_ date: Date) -> Bool {
        //祝日判定用のカレンダークラスのインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        
        //祝日判定を行う日にちの年月日を取得する
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        
        let holiday = CalculateCalendarLogic()
        
        return holiday.judgeJapaneseHoliday(year: year, month: month, day: day)
    }
    
    //曜日判定
    func getWeekIdx(_ date: Date) -> Int {
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    //土日や祝日の色を変える
    func calendar(_ calendar: FSCalendar, appearance apperance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //祝日判定をする
        if self.judgeHoliday(date) {
            return UIColor.red
        }
        
        //土日の判定
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return UIColor.red
        }
        else if weekday == 7{
            return UIColor.blue
        }
        return nil
    }
    //カレンダー処理
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //日付取得用のカレンダーインスタンス
        let tmpCalendar = Calendar(identifier: .gregorian)
        //月日を取得する
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        let y = String(format: "%04d", year)
        let m = String(format: "%02d", month)
        let d = String(format: "%02d", day)
        
        //クリックしたら日付が表示される
        selectedDateLabel.text = "\(y)/\(m)/\(d)"
        
        //getschedule関数の呼び出し
        getschedule(date: selectedDateLabel.text!)
    }
    
    //スケジュール取得
    func getschedule(date: String) {
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        //ここは'と"が両方存在しているので数と場所に注意してください
        result = result.filter("date = '\(date)'")
        if let event = result.last {
            print(event.event)
            contentLabel.text = event.event
            contentLabel.textColor = .black
        } else {
            contentLabel.text = "スケジュールはありません"
            contentLabel.textColor = .black
        }
    }
    
    //画面遷移
    @objc func onClick() {
        UserDefaults.standard.set(selectedDateLabel.text, forKey: "selectedDate")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let SecondController = storyboard.instantiateViewController(withIdentifier: "Insert")
        present(SecondController, animated: true, completion: nil)
    }
    
    

}

