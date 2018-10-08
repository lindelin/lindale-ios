//
//  SyncController.swift
//  lindale-watch Extension
//
//  Created by LINDALE on 2018/10/08.
//  Copyright © 2018 lindelin. All rights reserved.
//

import WatchKit
import Foundation


class SyncController: WKInterfaceController {
    
    static let controllerIdentifier = "Sync"

    @IBOutlet weak var syncButton: WKInterfaceButton!
    @IBOutlet weak var info: WKInterfaceLabel!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func sync() {
        self.syncButton.setTitle("同期中...")
        WatchSession.main.sendMessage(message: ["request": "Auth"]) { (replyData) in
            if let replyData = replyData, replyData["type"] as? String == "AuthInfo" {
                let value = replyData["data"] as! [String : Any]
                OAuth.store(info: value)
                self.syncButton.setTitle("同期")
                self.info.setText("同期完了しました。")
                WKInterfaceController.reloadRootControllers(withNames: [TasksController.controllerIdentifier, TodosController.controllerIdentifier], contexts:  nil)
            } else {
                self.info.setText("同期失敗しました。iPhone 側がログインしたかご確認してください。")
                self.syncButton.setTitle("リトライ")
            }
        }
    }
    
}
