//
//  SearchViewController.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/08.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    // 検索設定値保持キー
    let SETTING_KEY = "searchSettingKey"
    
    // UISearchControllerの変数保持用
    var searchController: UISearchController!
    
    @IBOutlet weak var searchOptionLabel: UILabel!
    
    
    // MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()

        // 検索結果を表示するSearchResultsControllerのインスタンスを生成
        let searchResultViewController = SearchResultViewController()
        
        // UISearchControllerのインスタンス生成＆検索結果画面をSearchResultsControllerに指定
        searchController = UISearchController(searchResultsController:searchResultViewController)
        
        // このクラスを表示の起点とする
        self.definesPresentationContext = true
        
        // ナビゲーションバーに検索窓を表示する
        self.navigationItem.searchController = searchController
        
        // タイトル設定
        self.title = "検索"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .automatic
        
        // 検索処理をSearchResultViewControllerで処理するよう指定
        searchController.searchBar.delegate = searchResultViewController
    }
    
    // MARK: -
    override func viewWillAppear(_ animated: Bool) {
        let settings = UserDefaults.standard
        if settings.string(forKey: SETTING_KEY) != nil {
            searchOptionLabel.text = settings.string(forKey: SETTING_KEY)
        } else {
            searchOptionLabel.text = "title"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
