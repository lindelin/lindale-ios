//
//  ProjectDetailController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/03.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import PageMenu

class ProjectDetailController: UIViewController {
    
    var project: ProjectCollection.Project!
    
    var controllers: [UIViewController] = []
    var pageMenu : CAPSPageMenu!
    let pageMenuOption: [CAPSPageMenuOption] = [
        .menuItemSeparatorWidth(4.3),
        .scrollMenuBackgroundColor(UIColor.white),
        .viewBackgroundColor(UIColor(red: 247.0/255.0, green: 247.0/255.0, blue: 247.0/255.0, alpha: 1.0)),
        .bottomMenuHairlineColor(UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 0.1)),
        .selectionIndicatorColor(Colors.themeMain),
        .menuMargin(20.0),
        .menuHeight(40.0),
        .selectedMenuItemLabelColor(Colors.themeMain),
        .unselectedMenuItemLabelColor(Colors.themeBaseSub),
        .menuItemFont(UIFont(name: "HelveticaNeue-Medium", size: 14.0)!),
        .useMenuLikeSegmentedControl(false),
        .menuItemSeparatorRoundEdges(true),
        .selectionIndicatorHeight(2.0),
        .menuItemSeparatorPercentageHeight(0.1)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.setUpNavigationBar()
        self.setUpPageMenu()
    }

    func setUpPageMenu() {
        
        let storyboard = UIStoryboard(name: "ProjectDetail", bundle: nil)
        
        let topController = storyboard.instantiateViewController(withIdentifier: ProjectTopController.identity) as! ProjectTopController
        topController.parentNavigationController = self.navigationController
        topController.project = self.project
        topController.title = "Top"
        controllers.append(topController)
        
        let infoController = storyboard.instantiateViewController(withIdentifier: ProjectInfoController.identity) as! ProjectInfoController
        infoController.parentNavigationController = self.navigationController
        infoController.project = self.project
        infoController.title = "Overview"
        controllers.append(infoController)
        
        let taskController = storyboard.instantiateViewController(withIdentifier: ProjectTaskController.identity) as! ProjectTaskController
        taskController.parentNavigationController = self.navigationController
        taskController.project = self.project
        taskController.title = "Tasks"
        controllers.append(taskController)
        
        let todoController = storyboard.instantiateViewController(withIdentifier: ProjectTodoController.identity) as! ProjectTodoController
        todoController.parentNavigationController = self.navigationController
        todoController.project = self.project
        todoController.title = "TODOs"
        controllers.append(todoController)
        
        let settingsController = storyboard.instantiateViewController(withIdentifier: ProjectSettingsController.identity) as! ProjectSettingsController
        settingsController.parentNavigationController = self.navigationController
        settingsController.project = self.project
        settingsController.title = "Settings"
        controllers.append(settingsController)
        
        self.pageMenu = CAPSPageMenu(viewControllers: self.controllers, frame: CGRect(x: 0, y: Size.naviBarHeight, width: self.view.frame.width, height: self.view.frame.height - Size.naviBarHeight - Size.tabBarHeight), pageMenuOptions: self.pageMenuOption)
        self.view.addSubview(self.pageMenu.view)
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    @IBAction func backToProjectList(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
