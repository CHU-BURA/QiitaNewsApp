//
//  SearchResultViewController.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/08.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage
import SVProgressHUD

class SearchResultViewController: UITableViewController {
    
    // 検索設定値保持キー
    let SETTING_KEY = "searchSettingKey"
    
    // 取得した記事データ保持用
    var dataList:[QiitaNewsModel] = []
    
    // 検索オプション
    var serchOption: String = "title"
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        // カスタムセルNewsCellを使用するため、UITableViewに登録
        let nib = UINib(nibName: "QiitaNewsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "QiitaNewsCell")
        
        let settings = UserDefaults.standard
        if settings.string(forKey: SETTING_KEY) != nil {
            serchOption = settings.string(forKey: SETTING_KEY)!
        } else {
            settings.register(defaults: [SETTING_KEY: serchOption])
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: -
    /*
     UITableViewのセクション数を設定する
     */
    override func numberOfSections(in tableView: UITableView) -> Int {
        // セクションは1つ
        return 1
    }

    // MARK: -
    /*
     UITableViewのセクションに表示する記事数を設定する
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 取得した記事数だけ表示
        return dataList.count
    }
    
    // MARK: -
    /*
     セルの表示内容を設定する
     */
    override func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // QiitaNewsCellのインスタンス生成＆すでに作られている場合は再利用
        let cell: QiitaNewsCell = tableView.dequeueReusableCell(withIdentifier: "QiitaNewsCell", for: indexPath) as! QiitaNewsCell
        
        // 取得したデータの取り出し
        let data = dataList[indexPath.row]
        
        // 取得したデータの設定
        let urlStr = data.user.profile_image_url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! // URL文字列のエンコード
        let url = URL(string: urlStr)! // URL型へ変換
        cell.createdAt.text = data.dateString
        cell.profileImage.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholderImage.png")) // 画像URLの設定
        cell.userName.text = data.user.id
        cell.title.text = data.title
        
        return cell
    }
    
    // MARK: -
    /*
     セル選択時の処理
     */
    override func tableView(_ tableView: UITableView,didSelectRowAt indexPath: IndexPath) {
        
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // データの取り出し
        let data = dataList[indexPath.row]
        
        // 記事URLを取得し、SFSafariViewControllerで表示
        if let url = URL(string: data.url) {
            // 次の画面へ遷移して、SFSafariViewControllerで表示する
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            self.present(controller, animated: true,completion: nil)
        }
    }
}




extension SearchResultViewController: UISearchBarDelegate {
    
    // MARK: -
    /*
     UISearchBar編集時の処理
     */
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // 検索窓の文字列に何かしら変化があるたびに呼ばれる
        // 保持しているデータを空にする
        self.dataList = []
        self.tableView.reloadData()
        return true
    }
    
    // MARK: -
    /*
     UISearchBar編集時における「検索」押下時の処理
     */
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 検索を押した時に処理
        reloadListDatas(searchBar.text!)
    }
    
    // MARK: -
    /*
     記事の検索、更新
     */
    func reloadListDatas(_ text:String) {
        // ローディング開始
        SVProgressHUD.show(withStatus: "Loading...")
        
        // 文字列が空の時は処理を行わない
        if text.isEmpty {
            return
        }
        // セッション用のコンフィグを設定・今回はデフォルトの設定
        let config = URLSessionConfiguration.default
        
        // NSURLSessionのインスタンスを生成
        let session = URLSession(configuration: config)
        
        let settings = UserDefaults.standard
        if settings.string(forKey: SETTING_KEY) != nil {
            serchOption = settings.string(forKey: SETTING_KEY)!
        }
        
        // 検索する文字列が日本語の場合もあるため、エンコードする
        let urlString = "https://qiita.com/api/v2/items?query=\(serchOption):\(text)"
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!)!
        
        // 通信処理タスクを設定
        let task = session.dataTask(with: url) {(data,response, error) in
            // エラーが発生したらアラートを表示して終了
            if error != nil {
                let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました。", preferredStyle: UIAlertControllerStyle.alert)
                controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                
                return
            }
            
            // JSON形式にデータを変換
            guard let jsonData: Data = data else {
                let controller : UIAlertController = UIAlertController(title: nil, message: "エラーが発生しました。", preferredStyle: UIAlertControllerStyle.alert)
                controller.addAction(UIAlertAction(title: "OK",style: UIAlertActionStyle.cancel, handler: nil))
                self.present(controller, animated: true, completion: nil)
                
                return
            }
            
            self.dataList = try! JSONDecoder().decode([QiitaNewsModel].self, from: jsonData)
            
            // メインスレッドに処理を戻す
            DispatchQueue.main.async {
                // 検索結果が0件だった場合はアラートを出す
                if self.dataList.isEmpty {
                    let controller : UIAlertController = UIAlertController(title: nil, message: "検索結果がありませんでした", preferredStyle: UIAlertControllerStyle.alert)
                    controller.addAction(UIAlertAction(title:"OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(controller, animated: true,completion: nil)
                    
                    return
                }
                
                // 最新のデータに更新する
                self.tableView.reloadData()
                
                // ローディング終了
                SVProgressHUD.dismiss()
            }
            
            // メモリリーク対応→未使用タスクをキャンセルする
            session.invalidateAndCancel()
        }
        // タスクを実行
        task.resume()
    }
}
