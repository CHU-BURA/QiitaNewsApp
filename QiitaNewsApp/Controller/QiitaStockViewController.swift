//
//  QiitaStockViewController.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/14.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit
import SafariServices
import SDWebImage
import SVProgressHUD

class QiitaStockViewController: UIViewController {
    
    // リフレッシュ
    let refreshControl: UIRefreshControl = UIRefreshControl()
    
    // 取得した記事データ保持用
    var dataList:[QiitaNewsModel] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // UIRefreshControlの追加
        tableView?.refreshControl = refreshControl
        
        // タイトル設定
        self.navigationItem.title = "ストック記事"
        if #available(iOS 11, *) {
            // iOS11以上の場合 → ラージタイトルの設定
            self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationItem.largeTitleDisplayMode = .automatic
        }
        
        // ファイルの読み込む
        let nib = UINib(nibName: "QiitaNewsCell", bundle: nil)
        
        // UITableViewにQiitaNewsCellを登録する
        tableView?.register(nib, forCellReuseIdentifier: "QiitaNewsCell")
        
        // 引っ張ったら更新した際に処理するメソッドを追加(リフレッシュ)
        refreshControl.addTarget(self, action: #selector(self.refreshReload(_:)), for: .valueChanged)
        
        // 画面表示時に行う通信処理を追加
        reloadListDatas()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: -
    /*
     引っ張って更新を行ったら実行されるメソッド
     */
    @objc func refreshReload(_ sender: UIRefreshControl) {
        // データを更新する
        self.reloadListDatas()
    }
    
    // MARK: -
    /*
     記事の更新
     */
    func reloadListDatas() {
        // ローディング開始
        SVProgressHUD.show(withStatus: "Loading...")
        
        // セッション用のコンフィグを設定・今回はデフォルトの設定
        let config = URLSessionConfiguration.default
        
        // NSURLSessionのインスタンスを生成
        let session = URLSession(configuration: config)
        
        // 接続するURLを指定
        let url = URL(string: "https://qiita.com/api/v2/users/_CHUBURA/stocks")
        
        // 通信処理タスクを設定
        let task = session.dataTask(with: url!) {(data, response, error) in
            
            // エラーが発生した場合にのみ処理
            if error != nil {
                // メインスレッドに処理を戻す
                DispatchQueue.main.async {
                    // もし引っ張って更新していたらUIを元に戻す
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    
                    // ここでエラーが発生したことをアラートで表示
                    let controller : UIAlertController = UIAlertController(title: nil,message: "エラーが発生しました。", preferredStyle: UIAlertControllerStyle.alert)
                    controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(controller, animated:true, completion: nil)
                }
                // ローディング終了
                SVProgressHUD.dismiss()
                return
            }
            
            // エラーがなければ、JSON形式にデータを変換して格納
            guard let jsonData: Data = data else {
                // メインスレッドに処理を戻す
                DispatchQueue.main.async {
                    // もし引っ張って更新していたらUIを元に戻す
                    if self.refreshControl.isRefreshing {
                        self.refreshControl.endRefreshing()
                    }
                    
                    // ここでエラーが発生したことをアラートで表示
                    let controller : UIAlertController = UIAlertController(title: nil,message: "エラーが発生しました。", preferredStyle: UIAlertControllerStyle.alert)
                    controller.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
                    self.present(controller, animated:true, completion: nil)
                }
                // ローディング終了
                SVProgressHUD.dismiss()
                return
            }
            
            self.dataList = try! JSONDecoder().decode([QiitaNewsModel].self, from: jsonData)
            
            // メインスレッドに処理を戻す
            DispatchQueue.main.async {
                // もし引っ張って更新していたらUIを元に戻す
                if self.refreshControl.isRefreshing {
                    self.refreshControl.endRefreshing()
                }
                // 最新のデータに更新する
                self.tableView.reloadData()
                
                // ローディング終了
                SVProgressHUD.dismiss()
            }
            
            // メモリリーク対応→未使用タスクをキャンセルする
            session.invalidateAndCancel()
        }
        // タスクを実施
        task.resume()
    }
}


extension QiitaStockViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: -
    /*
     UITableViewのセクション数を設定する
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        // セクションは1つ
        return 1
    }
    
    // MARK: -
    /*
     UITableViewのセクションに表示する記事数を設定する
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 取得したデータの数だけセルを表示
        return dataList.count
    }
    
    // MARK: -
    /*
     セルの表示内容を設定する
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // QiitaNewsCellのインスタンス生成
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        
        // データの取り出し
        let data = dataList[indexPath.row]
        
        // 記事URLを取得し、SFSafariViewControllerで表示
        if let url = URL(string: data.url) {
            // 次の画面へ遷移して、SFSafariViewControllerで表示する
            let controller: SFSafariViewController = SFSafariViewController(url: url)
            self.present(controller, animated: true, completion: nil)
        }
    }
}


