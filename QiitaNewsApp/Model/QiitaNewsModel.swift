//
//  QiitaNewsModel.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/08.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import Foundation

struct QiitaNewsModel: Codable {
    
    // 記事の作成日時
    var created_at: String = ""
    
    // ユーザ情報
    var user: User = User()
    struct User: Codable {
        // ID
        var id: String = ""
        // プロフィール画像
        var profile_image_url: String = ""
    }
    
    // 記事のURL
    var url: String = ""
    
    // 記事のタイトル
    var title: String = ""
    
    
    /*
     日付文字列を表示用フォーマットに変換する
     */
    var dateString: String {
        // NSDateFormatterインスタンス生成
        let formatter: DateFormatter = DateFormatter()
        // ロケール指定
        formatter.locale = Locale(identifier: "ja_JP")
        // 受け取るフォーマット設定
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'+'SS:SS"
        
        // 正常にDate型に変換できるか確認
        if let date = formatter.date(from: created_at) {
            // 表示するフォーマット指定
            formatter.dateFormat = "yyyy/MM/dd HH:mm"
            // String型へ変換
            let str = formatter.string(from: date)
            return str
        }
        
        // 失敗した場合は、そのまま"created_at"を返却する
        return created_at
    }
}
