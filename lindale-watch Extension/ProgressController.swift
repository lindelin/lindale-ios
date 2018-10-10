//
//  ProgressController.swift
//  lindale-watch Extension
//
//  Created by Jie Wu on 2018/10/09.
//  Copyright © 2018 lindelin. All rights reserved.
//

import WatchKit
import Foundation


class ProgressController: WKInterfaceController {
    
    static let controllerIdentifier = "Progress"
    
    var profile: Profile? = Profile.find()

    @IBOutlet weak var totalProgress: WKInterfaceGroup!
    @IBOutlet weak var taskProgress: WKInterfaceGroup!
    @IBOutlet weak var todoProgress: WKInterfaceGroup!
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        self.updateUI()
        self.loadData()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    @IBAction func refresh() {
        self.loadData()
    }
    
    func loadData() {
        if OAuth.isLogined {
            self.setTitle("Loading...")
            DispatchQueue.main.async {
                Profile.resources { (profile) in
                    if let profile = profile {
                        self.profile = profile
                        self.updateUI()
                    }
                }
            }
        } else {
            presentController(withName: "Sync", context: nil)
        }
    }
    
    func updateUI() {
        if let profile = self.profile {
//            self.setTotalProgress(profile.progress.total)
//            self.setTaskProgress(profile.progress.task)
//            self.setTodoProgress(profile.progress.todo)
            self.totalProgress.setBackgroundImage(UIImage(named: "green-\(profile.progress.total)-large"))
            self.taskProgress.setBackgroundImage(UIImage(named: "yellow-\(profile.progress.task)-large"))
            self.todoProgress.setBackgroundImage(UIImage(named: "red-\(profile.progress.todo)-large"))
            self.setTitle("Progress")
        }
    }
    
    func setTotalProgress(_ progress: Int) {
        var images: [UIImage]! = []
        for i in 0...progress {
            let name = "green-\(i)-large"
            images.append(UIImage(named: name)!)
        }
        let progressImages = UIImage.animatedImage(with: images, duration: 2)
        self.totalProgress.setBackgroundImage(progressImages)
        self.totalProgress.startAnimatingWithImages(in: NSRange(location: 0, length: progress), duration: 2, repeatCount: 1)
    }
    
    func setTaskProgress(_ progress: Int) {
        var images: [UIImage]! = []
        for i in 0...progress {
            let name = "yellow-\(i)-large"
            images.append(UIImage(named: name)!)
        }
        let progressImages = UIImage.animatedImage(with: images, duration: 2)
        self.taskProgress.setBackgroundImage(progressImages)
        self.taskProgress.startAnimatingWithImages(in: NSRange(location: 0, length: progress), duration: 2, repeatCount: 1)
    }
    
    func setTodoProgress(_ progress: Int) {
        var images: [UIImage]! = []
        for i in 0...progress {
            let name = "red-\(i)-large"
            images.append(UIImage(named: name)!)
        }
        let progressImages = UIImage.animatedImage(with: images, duration: 2)
        self.todoProgress.setBackgroundImage(progressImages)
        self.todoProgress.startAnimatingWithImages(in: NSRange(location: 0, length: progress), duration: 2, repeatCount: 1)
    }

}
