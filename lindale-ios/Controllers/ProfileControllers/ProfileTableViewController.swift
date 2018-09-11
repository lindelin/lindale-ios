//
//  ProfileTableViewController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/07.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    var profile: Profile? = Profile.find()
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var projectCount: UILabel!
    @IBOutlet weak var taskCount: UILabel!
    @IBOutlet weak var todoCount: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.loadData), for: .valueChanged)
        
        self.updateUI()
        self.loadData()
    }
    
    @objc func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Profile.resources { (profile) in
            if let profile = profile {
                self.updateUI(with: profile)
                self.refreshControl?.endRefreshing()
            } else {
                //self.logout()
            }
        }
    }
    
    func updateUI(with profile: Profile? = nil) {
        if profile != nil {
            self.profile = profile
        }
        if self.profile != nil {
            self.photo.load(url: URL(string: (self.profile?.photo!)!)!, placeholder: #imageLiteral(resourceName: "lindale-launch"))
            self.projectCount.text = self.profile?.status.projectCount.description
            self.taskCount.text = self.profile?.status.unfinishedTaskCount.description
            self.todoCount.text = self.profile?.status.unfinishedTodoCount.description
            self.name.text = self.profile?.name
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int)
        -> String? {
            return "進捗"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var cellCount = 0
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cellCount = 1
            break
        case 1:
            cellCount = 2
            break
        case 2:
            cellCount = 3
            break
        default:
            break
        }
        
        return cellCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatusCell", for: indexPath)
        
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatusCell", for: indexPath)
            break
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatusCell", for: indexPath)
            break
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatusCell", for: indexPath)
            break
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileStatusCell", for: indexPath)
            break
        }
        
        
        // Configure the cell...
        
        return cell
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.tableView.reloadData()
            break
        case 1:
            self.tableView.reloadData()
            break
        case 2:
            self.tableView.reloadData()
            break
        default:
            break
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        self.logout()
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
