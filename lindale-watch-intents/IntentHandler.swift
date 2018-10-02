//
//  IntentHandler.swift
//  lindale-watch-intents
//
//  Created by Jie Wu on 2018/09/28.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        guard intent is TaskIntent else {
            fatalError("Unhandled intent type: \(intent)")
        }
        return TaskIntentHandler()
    }
    
}
