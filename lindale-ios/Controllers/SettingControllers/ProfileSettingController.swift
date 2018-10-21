//
//  ProfileSettingController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/21.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class ProfileSettingController: UITableViewController {
    
    var profile: Profile!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var content: UITextView!
    @IBOutlet weak var organization: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.updateUI()
    }
    
    func updateUI() {
        self.name.text = self.profile.name
        self.content.text = self.profile.content
        self.organization.text = self.profile.company
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
