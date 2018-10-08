//
//  ShortcutManager.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/30.
//  Copyright © 2018 lindelin. All rights reserved.
//

import Foundation
import Intents
import os.log

class ShortcutManager {
    //静态单例
    static let main = ShortcutManager()
    
    var shortcuts: [INRelevantShortcut] = []
    var taskShortcut: INRelevantShortcut? = nil
    var todoShortcut: INRelevantShortcut? = nil
    
    
    
    public func updateTaskShortcut(shortcut task: TaskShortcut) {
        
        var relevanceProviders: [INRelevanceProvider] = []
        
        //let taskIntent = task.intent
        let userActivity = task.userActivity
        
        let shortcut = INShortcut(userActivity: userActivity)
        
        let suggestedShortcut = INRelevantShortcut(shortcut: shortcut)
        
        let template = INDefaultCardTemplate(title: task.title)
        // Need a different string for the subtitle because of capitalization difference
        template.subtitle = task.status
        
        suggestedShortcut.watchTemplate = template
        
        // Make a lunch suggestion when arriving to work.
        let routineRelevanceProvider = INDailyRoutineRelevanceProvider(situation: .work)
        relevanceProviders.append(routineRelevanceProvider)
        
//        if task.startAt != nil {
//            let dateRelevanceProvider = INDateRelevanceProvider(start: Date(), end: nil)
//            relevanceProviders.append(dateRelevanceProvider)
//        }
        
        // This sample uses a single relevance provider, but using multiple relevance providers is supported.
        suggestedShortcut.relevanceProviders = relevanceProviders
        
        self.taskShortcut = suggestedShortcut
        
        self.storeShortcuts()
    }
    
    public func updateTodoShortcut(shortcut todo: TodoShortcut) {
        
        var relevanceProviders: [INRelevanceProvider] = []
        
        //let taskIntent = task.intent
        let userActivity = todo.userActivity
        
        let shortcut = INShortcut(userActivity: userActivity)
        
        let suggestedShortcut = INRelevantShortcut(shortcut: shortcut)
        
        let template = INDefaultCardTemplate(title: todo.content)
        // Need a different string for the subtitle because of capitalization difference
        template.subtitle = todo.status
        
        suggestedShortcut.watchTemplate = template
        
        // Make a lunch suggestion when arriving to work.
        let routineRelevanceProvider = INDailyRoutineRelevanceProvider(situation: .work)
        relevanceProviders.append(routineRelevanceProvider)
        
        // This sample uses a single relevance provider, but using multiple relevance providers is supported.
        suggestedShortcut.relevanceProviders = relevanceProviders
        
        self.todoShortcut = suggestedShortcut
        
        self.storeShortcuts()
    }
    
    private func storeShortcuts() {
        self.shortcuts = []
        
        if let taskShortcut = self.taskShortcut {
            self.shortcuts.append(taskShortcut)
        }
        
        if let todoShortcut = self.todoShortcut {
            self.shortcuts.append(todoShortcut)
        }
        
        INRelevantShortcutStore.default.setRelevantShortcuts(self.shortcuts) { (error) in
            if let error = error as NSError? {
                os_log("Providing relevant shortcut failed. \n%@", log: OSLog.default, type: .error, error)
            } else {
                os_log("Providing relevant shortcut succeeded.")
            }
        }
    }
}
