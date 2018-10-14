//
//  SearchSettingViewController.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/11.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit

class SearchSettingViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    
    // 検索設定値保持キー
    let SETTING_KEY = "searchSettingKey"
    
    // 検索オプション
    let searchOptions: Array = [
        "title", "body", "code", "tag", "user"
    ]
    
    @IBOutlet weak var searchPicker: UIPickerView!
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        // タイトル設定
        self.title = "検索オプション"
        
        // UIPickerView設定
        searchPicker.delegate = self
        searchPicker.dataSource = self
        
        // 格納データの取得
        let settings = UserDefaults.standard
        let searchSetting = settings.string(forKey: SETTING_KEY)
        
        // UIPickerViewに検索オプションを設定
        for row in 0..<searchOptions.count {
            if searchOptions[row] == searchSetting {
                searchPicker.selectRow(row, inComponent: 0, animated: true)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: -
    /*
     PickerViewの列数指定
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // 時間設定のみのため1
    }
    
    // MARK: -
    /*
     PickerViewの行数指定
     */
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return searchOptions.count
    }
    
    // MARK: -
    /*
     PickerViewの表示設定
     */
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return searchOptions[row]
    }
    
    // MARK: -
    /*
     PickerView選択時の処理
     */
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 検索設定値を格納する
        let settings = UserDefaults.standard
        settings.setValue(searchOptions[row], forKey: SETTING_KEY)
        settings.synchronize()
    }
    
    // MARK: -
    /*
     「完了」押下時の処理
     */
    @IBAction func completedButtonTapped(_ sender: Any) {
        // 画面を閉じて、SearchViewControllerへ戻る処理
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: -
    /*
     「キャンセル」押下時の処理
     */
    @IBAction func onCancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
