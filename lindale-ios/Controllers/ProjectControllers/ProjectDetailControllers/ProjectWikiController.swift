//
//  ProjectWikiController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/12.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD
import Floaty
import SCLAlertView

class ProjectWikiController: UITableViewController {
    
    static let identity = "ProjectWiki"
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    var wikiTypes: [WikiType]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupFloatyButton()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.wikiTypeHasUpdated, object: nil)
    }
    
    private func setupFloatyButton() {
        let floaty = Floaty()
        floaty.addItem(trans("wiki.add-index"), icon: UIImage(named: "book-30")!, handler: { item in
            let appearance = SCLAlertView.SCLAppearance(
                showCircularIcon: false
            )
            let alert = SCLAlertView(appearance: appearance)
            let textField = alert.addTextField()
            alert.addButton(trans("wiki.add-index")) {
                KRProgressHUD.show()
                
                let register = WikiTypeRegister(id: nil, name: textField.text, projectId: self.project.id)
                register.store(completion: { (response) in
                    guard response["status"] == "OK" else {
                        KRProgressHUD.dismiss()
                        self.showAlert(title: nil, message: response["messages"]!)
                        return
                    }
                    
                    NotificationCenter.default.post(name: LocalNotificationService.wikiTypeHasUpdated, object: nil)
                    
                    KRProgressHUD.dismiss({
                        KRProgressHUD.showSuccess(withMessage: response["messages"]!)
                    })
                })
            }
            alert.showCustom(trans("wiki.add-index"),
                             subTitle: "",
                             color: Colors.themeBlue,
                             icon: UIImage(),
                             closeButtonTitle: trans("wiki.cancel"))
            floaty.close()
        })
        floaty.addItem(trans("wiki.submit"), icon: UIImage(named: "wiki-30")!, handler: { item in
            let storyboad = UIStoryboard(name: "ProjectWiki", bundle: nil)
            let controller = storyboad.instantiateViewController(withIdentifier: ProjectWikiCreateController.identity) as! ProjectWikiCreateController
            controller.parentNavigationController = self.parentNavigationController
            controller.project = self.project
            controller.wikiTypes = self.wikiTypes
            self.parentNavigationController?.pushViewController(controller, animated: true)
            floaty.close()
        })
        floaty.sticky = true
        floaty.buttonColor = Colors.themeGreen
        floaty.plusColor = UIColor.white
        self.view.addSubview(floaty)
    }
    
    @objc func loadData() {
        KRProgressHUD.show()
        WikiType.resources(project: self.project) { (wikiTypes) in
            self.refreshControl?.endRefreshing()
            KRProgressHUD.dismiss()
            
            guard let wikiTypes = wikiTypes else {
                self.authErrorHandle()
                return
            }
            
            self.wikiTypes = wikiTypes
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let wikiTypes = self.wikiTypes else {
            return 0
        }
        
        return wikiTypes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WikiTypeCell", for: indexPath)

        cell.textLabel?.text = self.wikiTypes![indexPath.row].name
        cell.imageView?.image = UIImage(named: "book-30")
        cell.imageView?.tintColor = Colors.themeMain

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.wikiTypes![indexPath.row]
        let storyboard = UIStoryboard(name: "ProjectWiki", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: ProjectWikisController.identity) as! ProjectWikisController
        controller.parentNavigationController = self.parentNavigationController
        controller.project = self.project
        controller.wikiTypes = self.wikiTypes
        controller.wikiType = type
        self.parentNavigationController?.pushViewController(controller, animated: true)
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
