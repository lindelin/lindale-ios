//
//  ProjectInfoController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import Down
import KRProgressHUD

class ProjectInfoController: UITableViewController {
    
    static let identity = "ProjectInfo"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pl: UILabel!
    @IBOutlet weak var sl: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var endAt: UILabel!
    @IBOutlet weak var contents: UILabel!
    
    // MARK: - language label
    @IBOutlet weak var langLabelPL: UILabel!
    @IBOutlet weak var langLabelSL: UILabel!
    @IBOutlet weak var langLabelStart: UILabel!
    @IBOutlet weak var langLabelEnd: UILabel!
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    
    func setupLangLabel() {
        self.langLabelPL.text = trans("member.pl")
        self.langLabelSL.text = trans("member.sl")
        self.langLabelStart.text = trans("project.start_at")
        self.langLabelEnd.text = trans("project.end_at")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupLangLabel()
        self.loadData()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 1:
            return trans("project.content")
        default:
            return nil
        }
    }
    
    @objc func loadData() {
        KRProgressHUD.show()
        self.image.load(url: self.project.image, placeholder: UIImage(named: "lindale-launch"))
        self.pl.text = project.pl.name
        self.sl.text = project.sl?.name
        self.startAt.text = project.start
        self.endAt.text = project.end
        
        DispatchQueue.main.async {
            if let content = self.project.content {
                let md = Down(markdownString: content)
                self.contents.attributedText = try? md.toAttributedString()
            } else {
                self.contents.text = trans("project.none")
            }
            self.updateUI()
            KRProgressHUD.dismiss()
        }
    }
    
    func updateUI() {
        self.tableView.reloadData()
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
