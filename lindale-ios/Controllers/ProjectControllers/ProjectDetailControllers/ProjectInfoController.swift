//
//  ProjectInfoController.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/12/04.
//  Copyright © 2018 lindelin. All rights reserved.
//

import UIKit
import Down

class ProjectInfoController: UITableViewController {
    
    static let identity = "ProjectInfo"
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var pl: UILabel!
    @IBOutlet weak var sl: UILabel!
    @IBOutlet weak var startAt: UILabel!
    @IBOutlet weak var endAt: UILabel!
    @IBOutlet weak var contents: UILabel!
    
    var parentNavigationController: UINavigationController?
    var project: ProjectCollection.Project!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.updateUI()
        }
    }
    
    func updateUI() {
        self.image.load(url: self.project.image, placeholder: UIImage(named: "lindale-launch"))
        self.pl.text = project.pl.name
        self.sl.text = project.sl?.name
        self.startAt.text = project.start
        self.endAt.text = project.end
        
        if let content = project.content {
            let md = Down(markdownString: content)
            self.contents.attributedText = try? md.toAttributedString()
        } else {
            self.contents.text = nil
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
