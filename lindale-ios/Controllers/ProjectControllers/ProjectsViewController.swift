//
//  ProjectsViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/08/31.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectsViewController: UITableViewController {
    
    var projectCollection: ProjectCollection? = ProjectCollection.find()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.updateUI()
        self.loadData()
    }
    
    private func setupNavigation() {
        let titleImageView = UIImageView(image: UIImage(named: "logo"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
    }
    
    @objc func loadData() {
        ProjectCollection.resources { (projectCollection) in
            if let projectCollection = projectCollection {
                self.projectCollection = projectCollection
                self.updateUI()
            } else {
                self.authErrorHandle()
            }
            self.refreshControl?.endRefreshing()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.projectCollection?.projects.count) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = String(describing: ProjectTableViewCell.self)
        let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as! ProjectTableViewCell

        cell.setCell(project: (self.projectCollection?.projects[indexPath.row])!)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (_, _, completion) in
            let text = "\(self.projectCollection?.projects[indexPath.row].title ?? ""):https://lindale.stg.lindelin.org/projects/\(self.projectCollection?.projects[indexPath.row].id.description ?? "")"
            let image = image_from(url: (self.projectCollection?.projects[indexPath.row].image))
            let activity = UIActivityViewController(activityItems: [text, image], applicationActivities: nil)
            
            if let pc = activity.popoverPresentationController {
                if let cell = tableView.cellForRow(at: indexPath) {
                    pc.sourceView = cell
                    pc.sourceRect = cell.bounds
                }
            }
            
            self.present(activity, animated: true)
        }
        
        shareAction.backgroundColor = Colors.themeMain
        
        let config = UISwipeActionsConfiguration(actions: [shareAction])
        
        return config
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let projectCollection = self.projectCollection {
            let lastCell = projectCollection.projects.count - 1
            if lastCell == indexPath.row {
                guard let nextPage = projectCollection.links.next else {
                    return
                }
                self.loadMoreData(url: nextPage)
            }
        }
    }
    
    func loadMoreData(url: URL) {
        KRProgressHUD.show(withMessage: "Loding...")
        ProjectCollection.more(nextUrl: url) { (projectCollection) in
            if let projectCollection = projectCollection {
                self .projectCollection?.links = projectCollection.links
                self .projectCollection?.meta = projectCollection.meta
                self .projectCollection?.projects.append(contentsOf: projectCollection.projects)
                self.updateUI()
                KRProgressHUD.dismiss()
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
