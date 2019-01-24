//
//  ProjectMemberController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/12.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectMemberController: UITableViewController {
    
    static let identity = "ProjectMember"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var projectMember: ProjectMember?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
    }
    
    @objc func loadData() {
        KRProgressHUD.show()
        ProjectMember.resources(project: self.project) { (projectMember) in
            self.refreshControl?.endRefreshing()
            KRProgressHUD.dismiss()
            
            guard let projectMember = projectMember else {
                self.authErrorHandle()
                return
            }
            
            self.projectMember = projectMember
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let projectMember = self.projectMember else {
            return 0
        }
        
        if let _ = projectMember.sl {
            return projectMember.members.count + 2
        }
        
        return projectMember.members.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProjectMemberCell.identity, for: indexPath) as! ProjectMemberCell
        
        var leaderCount: Int {
            return self.projectMember!.sl == nil ? 1 : 2
        }
        
        if indexPath.row == 0 {
            cell.update(user: self.projectMember!.pl, role: .pl)
        } else if let sl = self.projectMember!.sl, indexPath.row == 1 {
            cell.update(user: sl, role: .sl)
        } else {
            cell.update(user: self.projectMember!.members[indexPath.row - leaderCount], role: .mb)
        }
        
        return cell
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
