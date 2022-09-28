//
//  EventViewController.swift
//  NLabo-Swift-CalendarApp
//
//  Created by 髙津悠樹 on 2022/09/28.
//

import UIKit
import RealmSwift

class EventViewController: UIViewController {
    
    let eventTextView = UITextView(frame: CGRect(x: (width - 300) / 2, y: 100, width: 300, height: 400))
    let dateLabel = UILabel(frame: CGRect(x: (width - 300) / 2 , y: 70, width: 300, height: 20))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //キーボードを閉じるためのボタンを追加する
        //ツールバーを作成
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
        //閉じるボタンを右に配置するためのスペース
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        
        //閉じるボタン
        let commitButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.commitButtontapped))
        toolBar.items = [spacer,commitButton]
        eventTextView.inputAccessoryView = toolBar
        
        //スケジュール内容入力テキスト設定
        eventTextView.text = ""
        eventTextView.font = UIFont.systemFont(ofSize: 18)
        eventTextView.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 0.1)
        eventTextView.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        eventTextView.layer.borderWidth = 1.0
        eventTextView.layer.cornerRadius = 10.0
        view.addSubview(eventTextView)
        
        //戻るボタン
        let backBtn = UIButton(frame: CGRect(x: (width - 200) / 2, y: height - 50, width: 200, height: 30))
        backBtn.setTitle("戻る", for: UIControl.State())
        backBtn.setTitleColor(UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1), for: UIControl.State())
        backBtn.backgroundColor = .white
        backBtn.layer.cornerRadius = 10.0
        backBtn.layer.borderColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1).cgColor
        backBtn.layer.borderWidth = 1.0
        backBtn.addTarget(self, action: #selector(onbackClick), for: .touchUpInside)
        view.addSubview(backBtn)
        
        //日付表示設定
        dateLabel.backgroundColor = .white
        dateLabel.textAlignment = .center
        dateLabel.font = UIFont.systemFont(ofSize: 16)
       // dateLabel.text = "2022/09/29"
        let selectedDate = UserDefaults.standard.object(forKey: "selectedDate") as! String
        dateLabel.text = selectedDate
        view.addSubview(dateLabel)
        
        //カレンダーに保存ボタン
        let saveButton = UIButton(frame: CGRect(x: (width - 200) / 2, y: height - 100, width: 200, height: 50))
        saveButton.setTitle("カレンダーに保存", for: UIControl.State())
        saveButton.setTitleColor(.white, for: UIControl.State())
        saveButton.backgroundColor = UIColor(red: 30/255, green: 144/255, blue: 255/255, alpha: 1)
        saveButton.addTarget(self, action: #selector(saveEvent), for: .touchUpInside)
        view.addSubview(saveButton)
        
        getschedule(date: dateLabel.text!)
        
        
    }
    //スケジュール取得
    func getschedule(date: String) {
        let realm = try! Realm()
        var result = realm.objects(Event.self)
        result = result.filter("date = '\(date)'")
        if let event = result.last {
            print(event.event)
            eventTextView.text = event.event
        } else {
            return
        }
    }
    
    //画面遷移
    @objc func onbackClick(){
        dismiss(animated: true, completion: nil)
    }
    //キーボードを閉じる
    @objc func commitButtontapped() {
        self.view.endEditing(true)
    }
    //DB書き込み処理
    @objc func saveEvent(){
        print("データ書き込み開始")
        let realm = try! Realm()
        try! realm.write {
            //日付表示の内容と入力の内容が書き込まれる
            let events = [Event(value: ["date": dateLabel.text, "event": eventTextView.text])]
            realm.add(events)
            print(events)
            print("データ書き込み中")
            
        }
        print("データ書き込み完了")
        
        //前のページに戻る
        dismiss(animated: true, completion: nil)
    }

}
