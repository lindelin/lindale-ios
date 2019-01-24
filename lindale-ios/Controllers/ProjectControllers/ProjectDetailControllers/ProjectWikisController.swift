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
        self.setupFloatyButton()
        
        // MARK: - Refresh Control Config
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.loadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadData), name: LocalNotificationService.wikiHasUpdated, object: nil)
    }
    
    private func setupFloatyButton() {
        let size: CGFloat = 56
        let margin: CGFloat = 14
        let floaty = Floaty(frame: CGRect(x: self.view.frame.origin.x,
                                          y: self.view.frame.origin.y - margin - size - Size.tabBarHeight,
                                          width: size,
                                          height: size))
        floaty.addItem(trans("wiki.add-index"), icon: UIImage(named: "book-30")!, handler: { item in
            // TODO
            floaty.close()
        })
        floaty.addItem(trans("wiki.submit"), icon: UIImage(named: "wiki-30")!, handler: { item in
            // TODO
            floaty.close()
        })
        floaty.sticky = true
        floaty.buttonColor = Colors.themeGreen
        floaty.plusColor = UIColor.white
        floaty.tabBarHeight = Size.tabBarHeight
        self.view.addSubview(floaty)
    }
    
    private func setupNavigation() {
        self.navigationItem.title = self.wikiType.name
        let backButton = UIBarButtonItem(image: UIImage(named: "back-30"), style: .plain, target: self, action: #selector(self.backButtonTapped))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc func loadData() {
        KRProgressHUD.show()
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
    
    @objc func backButtonTapped(_ sender: UIBarButtonItem) {
        self.parentNavigationController?.popViewController(animated: true)
    }
}
