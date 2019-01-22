//
//  LocaleConfigurationService.swift
//  lindale-ios
//
//  Created by Jie Wu on 2019/01/22.
//  Copyright © 2019 lindelin. All rights reserved.
//

import UIKit
import KRProgressHUD

struct LanguageService {
    var languageResource: [String: [String: String]]?
    
    static var main = LanguageService()
    
    static func sync() {
        KRProgressHUD.show()
        NetworkProvider.main.data(request: .languageResource) { (data) in
            guard let data = data else {
                return
            }
            
            let languageResource = try! JSONDecoder.main.decode([String: [String: String]].self, from: data)
            LanguageService.main.languageResource = languageResource
            
            let coder = JSONEncoder()
            let languageResourceFile = try! coder.encode(languageResource)
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("LanguageResource").appendingPathExtension("json")
            try! languageResourceFile.write(to: archiveURL)
            print("保存成功：", archiveURL)
            KRProgressHUD.dismiss()
        }
    }
    
    func update() {
        let coder = JSONDecoder()
        do {
            let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
            let archiveURL = cachesDirectory.appendingPathComponent("LanguageResource").appendingPathExtension("json")
            let data = try Data(contentsOf: archiveURL)
            let languageResource = try coder.decode([String: [String: String]].self, from: data)
            LanguageService.main.languageResource = languageResource
        } catch {
            print("None Language Resources")
        }
    }
    
    func trans(_ key: String) -> String {
        guard let languageResource = self.languageResource else {
            return key
        }
        
        let split = key.components(separatedBy: ".")
        return languageResource[split[0]]?[split[1]] ?? key
    }
}

func trans(_ key: String) -> String {
    return LanguageService.main.trans(key)
}

