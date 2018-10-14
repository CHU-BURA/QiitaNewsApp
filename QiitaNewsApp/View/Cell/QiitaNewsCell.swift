//
//  QiitaNewsCell.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/09.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit

class QiitaNewsCell: UITableViewCell {
    
    // 作成日時
    @IBOutlet weak var createdAt: UILabel!
    // プロフィール画像
    @IBOutlet weak var profileImage: UIImageView!
    // ユーザ名
    @IBOutlet weak var userName: UILabel!
    // タイトル
    @IBOutlet weak var title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
