//
//  ProjectInfoController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class ProjectInfoController: UITableViewController {
    
    static let identity = "ProjectInfo"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.tableView.contentInset)
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
