//
//  LanguageSettingController.swift
//  lindale-ios
//
//  Created by LINDALE on 2018/10/20.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit

class LanguageSettingController: UITableViewController {
    
    var localeSettings: Settings.Locale!
    
    @IBOutlet weak var language: UILabel!
    @IBOutlet weak var langLabelLanguage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.updateUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refresh), name: LocalNotificationService.localeSettingsHasUpdated, object: nil)
    }
    
    func setup() {
        self.tableView.keyboardDismissMode = .onDrag
        self.navigationItem.title = trans("config.locale")
        self.navigationController?.navigationBar.barStyle = .default
        let textAttributes = [NSAttributedString.Key.foregroundColor: Colors.themeBase]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.langLabelLanguage.text = trans("project.lang")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            performSegue(withIdentifier: "UpdateLocale", sender: self.localeSettings)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "UpdateLocale" {
            let destination = segue.destination as! LocaleUpdateController
            destination.localeSettings = sender as? Settings.Locale
        }
    }
    
    func updateUI() {
        self.language.text = self.localeSettings.currentLanguageName
    }
    
    @objc func refresh() {
        Settings.Locale.load { (localeSettings) in
            if let localeSettings = localeSettings {
                self.localeSettings = localeSettings
                self.updateUI()
                self.setup()
            }
        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}
