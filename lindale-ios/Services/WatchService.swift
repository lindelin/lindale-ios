//
//  WatchService.swift
//  lindale-ios
//
//  Created by Jie Wu on 2018/09/13.
//  Copyright © 2018年 lindelin. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchSession: NSObject, WCSessionDelegate {
    //静态单例
    static let main = WatchSession()
    
    //初始化
    private override init()
    {
        super.init()
    }
    
    // 连接机制
    private let session:WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    // 激活会话对象
    func startSession(){
        session?.delegate = self
        session?.activate()
    }
    
    // 检测到watch端app
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("AppleWatch匹配完成")
    }
    
    // 通信完成会话对象开始闲置
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    // 通信完成会话对象释放
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    // watch侧发送数据过来，iPhone接收到数据并回复数据过去
    // message: watch侧发送过来的信息
    // replyHandler: iPhone回复过去的信息
    func session(_ session: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        
        let message = self.jsonDecode(data: messageData)
        
        if message["request"] as! String == "image" {
            let url = message["url"] as! String
            let cache = URLCache.shared
            let request = URLRequest(url: URL(string: url)!)
            if let data = cache.cachedResponse(for: request)?.data {
                replyHandler(data)
            } else {
                URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                    if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300 {
                        let cachedData = CachedURLResponse(response: response, data: data)
                        cache.storeCachedResponse(cachedData, for: request)
                        OperationQueue.main.addOperation {
                            replyHandler(data)
                        }
                    }
                }).resume()
            }
        }
    }
    
    // watch侧发送数据过来，iPhone接收到数据并回复数据过去
    // message: watch侧发送过来的信息
    // replyHandler: iPhone回复过去的信息
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        // 在这里，我们接收到watch发送过来的数据，可以用代理、代码块或者通知中心传值到ViewController，做出一系列操作。
        // 注！！：watch侧发送过来信息，iPhone回复直接在这个函数里回复replyHandler([String : Any])（replyHandler(数据)），这样watch侧发送数据的函数对应的reply才能接收到数据，别跟sendMessage这个函数混淆了。如果用sendMessage回复，那watch侧接收到信息就是didReceiveMessage的函数。
        var replyData: [String : Any] = [:]
        
        if message["request"] as! String == "projects" {
            let projectCollection = ProjectCollection.find()
            var data: [[String: Any]] = []
            if projectCollection != nil {
                for project in projectCollection!.projects {
                    let projectArray: [String: Any] = [
                        "title": project.title,
                        "image": project.image!,
                        "type": project.type ?? "Project"
                    ]
                    data.append(projectArray)
                }
            }
            replyData = ["projects": data]
            replyHandler(replyData)
        }
        
        if message["request"] as! String == "tasks" {
            let myTaskCollection = MyTaskCollection.find()
            var data: [[String: Any]] = []
            if myTaskCollection != nil {
                for task in myTaskCollection!.tasks {
                    let taskArray: [String: Any] = [
                        "title": task.title,
                        "project": task.projectName,
                        "type": task.type,
                        "status": task.status,
                        "progress": task.progress,
                        "color": task.color,
                    ]
                    data.append(taskArray)
                }
            }
            replyData = ["tasks": data]
            replyHandler(replyData)
        }
    
    }
    
    // iPhone向watch发送数据
    // key: 数据的key值
    // value: 数据内容
    func sendMessageToWatch(key:String,value:Any) {
        session?.sendMessage([key : value], replyHandler: { (dict:Dictionary) in
            // 这里是发送数据后的操作，比如写个alert提示发送成功
            // replyHandler是watch侧didReceiveMessage函数接收到信息后reply回复过来的内容，这里可以编辑自己需要的功能
        }, errorHandler: { (Error) in
            // 发送失败，一般是蓝牙没开，或手机开了飞行模式
        })
    }
    
    // Json Decode
    private func jsonDecode(data: Data) -> [String: Any] {
        let items = try? JSONSerialization.jsonObject(with: data) as! [String: Any]
        return items ?? [:]
    }

}
