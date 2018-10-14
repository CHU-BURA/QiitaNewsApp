//
//  MenuViewController.swift
//  QiitaNewsApp
//
//  Created by Sho Nozaki on 2018/10/13.
//  Copyright © 2018年 Sho Nozaki. All rights reserved.
//

import UIKit

// TODO: 未完成 → GiHubも導入したい
class MenuViewController: UIViewController{
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // メニュー位置設定
        let menuPosition = self.menuView.layer.position // メニュー画面の位置
        self.menuView.layer.position.x = -self.menuView.frame.width // 初期位置設定
        // 表示アニメーション
        UIView.animate(
            withDuration: 0.1,
            delay: 0,
            options: .curveEaseOut,
            animations: {
                self.menuView.layer.position.x = menuPosition.x
            },
            completion: { bool in
        })
    }
    
    /*
     メニュー外をタップした場合に非表示にする
     */
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        for touch in touches {
            if touch.view?.tag == 1 {
                UIView.animate(
                    withDuration: 0.2,
                    delay: 0,
                    options: .curveEaseIn,
                    animations: {
                        self.menuView.layer.position.x = -self.menuView.frame.width
                    },
                    completion: { bool in
                        self.tabBarController?.tabBar.isUserInteractionEnabled = false
                        self.dismiss(animated: true, completion: nil)
                    }
                )
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
