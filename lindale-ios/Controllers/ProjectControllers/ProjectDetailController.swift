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
        
        self.setUpProjectTop()
        self.setUpProjectInfo()
        self.setUpProjectTask()
        self.setUpProjectTodo()
        self.setUpProjectMember()
        self.setUpProjectWiki()
        //self.setUpProjectSettings()
        
        self.pageMenu = CAPSPageMenu(viewControllers: self.controllers, frame: CGRect(x: 0, y: Size.naviBarHeight, width: self.view.frame.width, height: self.view.frame.height - Size.naviBarHeight - Size.tabBarHeight), pageMenuOptions: self.pageMenuOption)
        self.pageMenu.controllerScrollView.isScrollEnabled = false
        self.view.addSubview(self.pageMenu.view)
    }
    
    private func setUpProjectTop() {
        let storyboard = UIStoryboard(name: "ProjectTop", bundle: nil)
        let contorller = storyboard.instantiateViewController(withIdentifier: ProjectTopController.identity) as! ProjectTopController
        contorller.parentNavigationController = self.navigationController
        contorller.project = self.project
        contorller.title = trans("header.top")
        controllers.append(contorller)
    }
    
    private func setUpProjectInfo() {
        let storyboard = UIStoryboard(name: "ProjectInfo", bundle: nil)
        let contorller = storyboard.instantiateViewController(withIdentifier: ProjectInfoController.identity) as! ProjectInfoController
        contorller.parentNavigationController = self.navigationController
        contorller.project = self.project
        contorller.title = trans("header.info")
        controllers.append(contorller)
    }
    
    private func setUpProjectTask() {
        let storyboard = UIStoryboard(name: "ProjectTask", bundle: nil)
        let contorller = storyboard.instantiateViewController(withIdentifier: ProjectTaskController.identity) as! ProjectTaskController
        contorller.parentNavigationController = self.navigationController
        contorller.project = self.project
        contorller.title = trans("header.tasks")
        controllers.append(contorller)
    }
    
    private func setUpProjectTodo() {
        let storyboard = UIStoryboard(name: "ProjectTodo", bundle: nil)
        let contorller = storyboard.instantiateViewController(withIdentifier: ProjectTodoController.identity) as! ProjectTodoController
        contorller.parentNavigationController = self.navigationController
        contorller.project = self.project
        contorller.title = "TODOs"
        controllers.append(contorller)
    }
    
    private func setUpProjectMember() {
        let storyboard = UIStoryboard(name: "ProjectMember", bundle: nil)
        let contorller = storyboard.instantiateViewController(withIdentifier: ProjectMemberController.identity) as! ProjectMemberController
        contorller.parentNavigationController = self.navigationController
        contorller.project = self.project
        contorller.title = trans("header.member")
        controllers.append(contorller)
    }
    
    private func setUpProjectWiki() {
        let storyboard = UIStoryboard(name: "ProjectWiki", bundle: nil)
        let contorller = storyboard.instantiateViewController(withIdentifier: ProjectWikiController.identity) as! ProjectWikiController
        contorller.parentNavigationController = self.navigationController
        contorller.project = self.project
        contorller.title = "Wiki"
        controllers.append(contorller)
    }
    
    private func setUpProjectSettings() {
        let storyboard = UIStoryboard(name: "ProjectSettings", bundle: nil)
        let contorller = storyboard.instantiateViewController(withIdentifier: ProjectSettingsController.identity) as! ProjectSettingsController
        contorller.parentNavigationController = self.navigationController
        contorller.project = self.project
        contorller.title = trans("header.config")
        controllers.append(contorller)
    }
    
    func setUpNavigationBar() {
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationItem.title = self.project.title
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
