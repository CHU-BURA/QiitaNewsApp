//
//  NotificationSettingViewController.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/08.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit
import UserNotifications

class NotificationSettingViewController: UIViewController {

    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var notificationButton: UIButton!
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // タイトル設定
        self.title = "通知設定"
        
        // 通知を管理するオブジェクトを一旦オフ・操作不可にする
        notificationSwitch.isOn = false
        datePicker.isEnabled = false
        notificationButton.isEnabled = false
        
        // 通知を取得
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            // 通知あり＝通知設定済み
            if requests.count > 0 {
                // UI変更を伴うため、メインスレッドで処理する
                DispatchQueue.main.async {
                    // スイッチをオンに変更
                    self.notificationSwitch.isOn = true
                    
                    // 時間変更、通知設定のボタン押下を行えるようにする
                    self.datePicker.isEnabled = true
                    self.notificationButton.isEnabled = true
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -
    /*
     「通知設定」押下時の処理
     */
    @IBAction func onNotificationButtonTapped(_ sender: UIButton) {
        // 通知を管理するクラスのシングルトンを取得
        let center = UNUserNotificationCenter.current()
        
        // datePickerで指定された時間を取得
        let date = datePicker.date
        
        // 通知を許可するリクエストを表示する（すでに許可するしないの画面が出ていれば表示されずに中の処理がすぐに処理される）
        center.requestAuthorization(options: [.alert, .sound],completionHandler: { granted, error in
            // エラーチェック
            if error != nil {
                let controller = UIAlertController(title: nil,message: "通知設定時にエラーが発生しました", preferredStyle:UIAlertControllerStyle.alert)
                controller.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.cancel, handler: nil))
                self.present(controller, animated: true,completion: nil)

                return
            }
            
            // 許可する・しないの結果によって処理を変更する
            if granted {
                // 予定されている全ての通知設定を削除してから通知設定を行う
                center.removeAllPendingNotificationRequests()
                
                // 通知の内容を設定
                let content = UNMutableNotificationContent()
                content.title = "最新の記事をチェックしましょう！" // 通知のタイトル
                content.subtitle = "今日はもう記事のチェックはしましたか？" // 通知のサブタイトル（iOS10から使用可能）
                content.body = "最新のニュースがありますよ！" // 通知の本文
                content.sound = UNNotificationSound.default() // 通知音の設定

                // カレンダーのインスタンスを生成
                let calendar = Calendar.current
                
                // 日付や時間をを数値で取得できるDateComponentsを作成
                // 今回はdatePickerで設定した時間を基に時間、分のみを取得
                let dateComponents = calendar.dateComponents([.hour, .minute], from: date)

                // どの時間で通知をするかを設定するか、繰り返し通知するかの設定
                // dateComponentsで設定した時間で通知。今回は繰り返し通知を行うので、repeatsはtrue
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents,repeats: true)

                // 通知内容と時間をもとにリクエスト作成
                let request = UNNotificationRequest(identifier:"NewsNotification", content:content, trigger:trigger)

                // 通知を設定する
                center.add(request, withCompletionHandler: nil)

                // 通知の設定完了時の表示を行う
                let controller = UIAlertController(title: nil,message: "\(dateComponents.hour!)時\(dateComponents.minute!)分に通知する設定を行いました", preferredStyle: UIAlertControllerStyle.alert)
                controller.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.default, handler: nil))
                self.present(controller, animated: true,completion: nil)
            } else {
                // 通知が許可されていない場合はここでアラートを表示
                let controller = UIAlertController(title: nil,message: "通知の設定が許可されていません。設定アプリから通知の設定をご確認ください。", preferredStyle: UIAlertControllerStyle.alert)
                controller.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.default, handler: nil))
                self.present(controller, animated: true,completion: nil)
            }
        })
    }
    
    // MARK: -
    /*
     UISwitch操作時の処理
     */
    @IBAction func onNotificationSwitchValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            // ボタン、UIDatePickerを有効にする
            datePicker.isEnabled = true
            notificationButton.isEnabled = true
        } else {
            // ボタン、UIDatePickerを無効にする
            datePicker.isEnabled = false
            notificationButton.isEnabled = false
            
            // 予定されている通知の解除
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
            
            // 通知解除時のアラート表示を行う
            let controller = UIAlertController(title: nil, message:"通知を解除しました", preferredStyle: UIAlertControllerStyle.alert)
            controller.addAction(UIAlertAction(title: "OK", style:UIAlertActionStyle.default, handler: nil))
            self.present(controller, animated: true, completion:nil)
        }
    }

    // MARK: -
    /*
     「✕(閉じる)」押下時の処理
     */
    @IBAction func onCloseButtonTapped(_ sender: UIBarButtonItem) {
        // 画面を閉じて、NewsViewControllerへ戻る処理
        self.dismiss(animated: true, completion: nil)
    }
}
