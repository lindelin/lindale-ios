//
//  LocaleUpdateController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

class LocaleUpdateController: UITableViewController {
    
    var localeSettings: Settings.Locale!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return localeSettings.optionObjs().count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocaleSelectCell", for: indexPath)

        cell.accessoryType = .none
        cell.textLabel?.text = self.localeSettings.optionObjs()[indexPath.row].value
        
        if self.localeSettings.optionObjs()[indexPath.row].key == self.localeSettings.currentLanguage {
            cell.accessoryType = .checkmark
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        KRProgressHUD.show(withMessage: "Updating...")
        let option = self.localeSettings.optionObjs()[indexPath.row]
        Settings.Locale.update(to: option.key) { (response) in
            guard response["status"] == "OK" else {
                KRProgressHUD.dismiss()
                self.showAlert(title: "Update error", message: response["messages"]!)
                return
            }
            KRProgressHUD.dismiss()
            self.localeSettings.currentLanguage = option.key
            self.localeSettings.currentLanguageName = option.value
            tableView.reloadData()
            LanguageService.sync()
            NotificationCenter.default.post(name: LocalNotificationService.localeSettingsHasUpdated, object: nil)
        }
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
