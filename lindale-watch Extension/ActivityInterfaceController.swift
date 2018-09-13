//
//  ActivityInterfaceController.swift
//  lindale-watch Extension
//
//  Created by LINDALE on 2018/09/13.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import WatchKit
import Foundation


class ActivityInterfaceController: WKInterfaceController {
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        WatchSession.main.startSession()
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        WatchSession.main.startSession()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
