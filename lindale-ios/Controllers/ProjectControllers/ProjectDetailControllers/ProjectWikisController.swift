//
//  ProjectWikisController.swift
//  lindale-ios
//
//  Created by Yuta Fuseki on 2018/12/25.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class ProjectWikisController: UITableViewController {

    static let identity = "ProjectWikis"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var wikiType: WikiType!
    var wikis: [Wiki]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.wikiHasUpdated, object: nil)
    }
    
    private func setupNavigation() {
        self.navigationItem.title = self.wikiType.name
    }
    
    @objc func loadData() {
        KRProgressHUD.show(withMessage: "Loading...")
        Wiki.resources(project: self.project, type: self.wikiType) { (wikis) in
            self.refreshControl?.endRefreshing()
            KRProgressHUD.dismiss()
            
            guard let wikis = wikis else {
                self.authErrorHandle()
                return
            }
            
            self.wikis = wikis
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let wikis = self.wikis else {
            return 0
        }
        
        return wikis.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WikiCell", for: indexPath)

        cell.textLabel?.text = self.wikis![indexPath.row].title
        cell.imageView?.image = UIImage(named: "wiki-30")
        cell.imageView?.tintColor = Colors.themeMain

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let wiki = self.wikis![indexPath.row]
        let storyboad = UIStoryboard(name: "ProjectWiki", bundle: nil)
        let controller = storyboad.instantiateViewController(withIdentifier: ProjectWikiDetailController.identity) as! ProjectWikiDetailController
        controller.parentNavigationController = self.parentNavigationController
        controller.wiki = wiki
        self.parentNavigationController?.pushViewController(controller, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
